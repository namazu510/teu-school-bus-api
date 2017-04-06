bundle install --path vendor/bundler
bundle exec rake db:create RAILS_ENV=production
bundle exec rake db:migrate RAILS_ENV=production
bundle exec rake schedule_fetch:default_schedule[http://www.teu.ac.jp/campus/access/2017_kihon-a_bus.html] RAILS_ENV=production
bundle exec rake schedule_fetch:default_schedule_saturday[http://www.teu.ac.jp/campus/access/2017_kihon-b_bus.html] RAILS_ENV=production
bundle exec rake schedule_fetch:irregular_date[http://www.teu.ac.jp/campus/access/006644.html] RAILS_ENV=production
bundle exec unicorn_rails -c ./config/unicorn.rb -E production -D --path /school_bus/