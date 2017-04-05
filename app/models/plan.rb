class Plan < ApplicationRecord
  has_many :operation_plans
  has_many :operations, through: :operation_plans

  has_many :schedules, dependent: :destroy
end
