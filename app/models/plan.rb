class Plan < ApplicationRecord
  has_many :schedules, dependent: :destroy
end
