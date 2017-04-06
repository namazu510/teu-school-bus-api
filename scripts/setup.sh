rake db:migrate
rake schedule_fetch:default_schedule[http://www.teu.ac.jp/campus/access/2017_kihon-a_bus.html]
rake schedule_fetch:default_schedule_saturday[http://www.teu.ac.jp/campus/access/2017_kihon-b_bus.html]
rake schedule_fetch:irregular_date[http://www.teu.ac.jp/campus/access/006644.html]