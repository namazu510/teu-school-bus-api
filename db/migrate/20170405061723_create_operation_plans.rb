  class CreateOperationPlans < ActiveRecord::Migration[5.0]
  def change
    create_table :operation_plans do |t|
      t.integer :operation_id
      t.integer :plan_id

      t.timestamps
    end
  end
end
