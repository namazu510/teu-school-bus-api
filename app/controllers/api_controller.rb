class ApiController < ApplicationController

  # 与えられた時刻から近い時間のバスを返す
  def next
    @from = params[:from]
    @to = params[:to]

    @time = params[:time] ||= Time.current
    par = params[:par] ||= 3

    operation = Operation.find_by_date(@time.to_date)
    operation ||= Operation.find_by_weekday(@time.wday)

    # from-toから該当plan導出
    section = [@from, @to]
    plan = operation.plans.find_by(from: section.min, to: section.max)

    # planないなら運行計画ない
    schedules_day = plan.schedules.where(from: @from)

    # これからのバスをpar件分探す
    @schedules = []
    time_tod = Tod::TimeOfDay(@time)
    schedules_day.each do |schedule|
      @schedules << schedule if (time_tod < schedule.departure_time)
      break if @schedules.size >= par
    end
  end

  def schedule_by_day
    @from = params[:from]
    @to = params[:to]
    @date = params[:day] || Date.current

    operation = Operation.find_by_date(@date)
    operation ||= Operation.find_by_weekday(@date.wday)

    section = [@from, @to]
    plan = operation.plans.find_by(from: section.min, to: section.max)

    @schedules = plan.schedules.where(from: @from, to: @to)
  end

  def irregular_schedule_day
    # 通常運行と違う日を返す. そのうち実装
  end

end
