require 'open-uri'
require 'wareki'

namespace :schedule_fetch do

  desc 'イレギュラーな運行日をスクレイピングで取る 引数で大学のスクールバス一覧ページ指定'
  task :irregular_date, ['url'] => :environment do |task, args|
    url = args.url

    charset = nil
    html = open(url) do |f|
      charset = f.charset
      f.read
    end

    doc = Nokogiri::HTML.parse(html, nil, charset)
    links = doc.css('.accessstyle ul a')

    links.each do |link|
      text = link.content
      url = 'http://www.teu.ac.jp' + link.attribute('href').text

      p text

      # 平成YY年M月D日MM月DD日・DD日・DD日のような日付をパースする
      irregular_days = []
      year = Date.current.strftime('%Jy')
      month = Date.current.month.to_s + '月'
      text.scan(/平成\d+年|\d+月|\d+日/) do |token|
        year = token if token.match(/平成\d+年/)
        month = token if token.match(/\d+月/)
        irregular_days << Date.parse(year + month + token) if token.match(/\d+日/)
      end
      next if irregular_days.empty?
      p irregular_days

      plans = parse_schedule_page(url)

      irregular_days.each do |irregular_date|
        # 既にその日のデータが登録されていれば新規追加しない
        next unless Operation.find_by_date(irregular_date).nil?

        irregular_operation = Operation.new
        irregular_operation.is_irregular = true
        irregular_operation.date = irregular_date
        irregular_operation.weekday = irregular_date.wday

        irregular_operation.plans << plans

        p irregular_date.to_s + 'のスケジュールをイレギュラー運行日として追加'

        irregular_operation.save
      end
    end
  end


  desc '大学のスクールバスの時刻表示から月～金データをスクレイピング'
  task :default_schedule, ['url'] => :environment do |task, args|
    url = args.url
    plans = parse_schedule_page(url)

    operations = []
    for i in 1..5
      operations << Operation.create(weekday: i, is_irregular: false)
    end

    operations.each do |operation|
      operation.plans << plans
      operation.save
    end
  end

  desc 'スクールバスの土曜日運行データをスクレイピング'
  task :default_schedule_saturday, ['url'] => :environment do |task, args|
    url = args.url
    plans = parse_schedule_page(url)

    operation = Operation.create(weekday: 6, is_irregular: false)
    operation.plans << plans
    operation.save
  end

  def parse_schedule_page(url)
    p 'open ' + url
    charset = nil
    html = open(url) do |f|
      charset = f.charset
      f.read
    end

    doc = Nokogiri::HTML.parse(html, nil, charset)
    # 1 = みなみの-大学
    # 2 = 八王子駅-大学
    # 3 = 学生会館行き
    # キャンパス-(TARGET)-キャンパス-備考
    plans = []
    doc.css('table').each_with_index  do |table, i|
      plan = Plan.new
      plan.source_url = url
      plan.from = 0

      plan.to = 1 if i == 0
      plan.to = 2 if i == 1
      plan.to = 3 if i == 2

      parse_table(plan, table)
      plans << plan
    end
    plans
  end

  def parse_table(plan, table)
    # スクールバスの時刻表テーブルをパースする
    # from - to - from - 備考

    table.css('tr').each_with_index  do |row, index|
      col1 = row.css('td')[0]
      next if col1.nil?

      col1 = row.css('td')[0].try(:inner_text)
      col2 = row.css('td')[1].try(:inner_text)
      col3 = row.css('td')[2].try(:inner_text)
      col4 = row.css('td')[3].try(:inner_text)

      # 時刻列か?
      if Tod::TimeOfDay.parsable? col1
        # 時刻列
        schedule = plan.schedules.build
        schedule.from = 0
        schedule.to = plan.to
        schedule.is_shuttle = false
        schedule.departure_time = Tod::TimeOfDay.parse(col1)
        schedule.arrival_time = Tod::TimeOfDay.parse(col2)

        schedule2 = plan.schedules.build
        schedule2.from = plan.to
        schedule2.to = 0
        schedule2.is_shuttle = false
        schedule2.departure_time = Tod::TimeOfDay.parse(col2)
        schedule2.arrival_time = Tod::TimeOfDay.parse(col3)

      else
        # 時刻列じゃない => シャトル運行
        # 前列と後列の時間, 運行間隔を元に確定する
        begin_row = table.css('tr')[index - 1]
        end_row = table.css('tr')[index + 1]

        schedule = plan.schedules.build
        schedule.from = 0
        schedule.to = plan.to
        schedule.is_shuttle = true

        schedule.begin = Tod::TimeOfDay.parse(begin_row.css('td')[1].inner_text)
        schedule.end = Tod::TimeOfDay.parse(end_row.css('td')[1].inner_text)
        #departure_timeはシャトル運行終了時刻にしておく(DB引く都合上)
        schedule.departure_time = schedule.end

        schedule.interval = col4

        schedule2 = plan.schedules.build
        schedule2.from = plan.to
        schedule2.to = 0
        schedule2.is_shuttle = true

        schedule2.begin = Tod::TimeOfDay.parse(begin_row.css('td')[2].inner_text)
        schedule2.end = Tod::TimeOfDay.parse(end_row.css('td')[2].inner_text)
        #departure_timeはシャトル運行終了時刻にしておく(DB引く都合上)
        schedule2.departure_time = schedule2.end

        schedule2.interval = col4
      end

    end
  end
end

