class CreateOperations < ActiveRecord::Migration[5.0]
  def change
    create_table :operations do |t|
      t.boolean :is_irregular
      t.integer :weekday
      t.date :date

      t.timestamps
    end
  end
end
