class CreateSchedules < ActiveRecord::Migration[5.0]
  def change
    create_table :schedules do |t|
      t.references :plan
      t.time :departure_time
      t.time :arrival_time
      t.integer :from
      t.integer :to
      t.boolean :is_shuttle
      t.time :begin
      t.time :end
      t.string :interval

      t.timestamps
    end
  end
end
