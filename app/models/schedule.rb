class Schedule < ApplicationRecord
  belongs_to :plan

  serialize :departure_time, Tod::TimeOfDay
  serialize :arrival_time, Tod::TimeOfDay
  serialize :begin, Tod::TimeOfDay
  serialize :end, Tod::TimeOfDay
end
