class Operation < ApplicationRecord
  has_many :operation_plans
  has_many :plans, through: :operation_plans
end
