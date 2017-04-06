json.from @from
json.to @to
json.time @time
json.schedules @schedules do |schedule|
  json.is_shuttle schedule.is_shuttle
  if schedule.is_shuttle
    json.begin schedule.begin.to_s
    json.end schedule.end.to_s
    json.interval schedule.interval
  else
    json.departure_time schedule.departure_time.to_s
    json.arrival_time schedule.arrival_time.to_s
  end
end