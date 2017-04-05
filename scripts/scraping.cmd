rake db:drop
rake db:migrate
rake schedule_fetch:default_schedule http://www.teu.ac.jp/campus/access/2016_kihon-a_bus2.html
rake schedule_fetch:default_schedule_saturday http://www.teu.ac.jp/campus/access/2016_kihon-b_bus2.html
rake schedule_fetch:irregular_date