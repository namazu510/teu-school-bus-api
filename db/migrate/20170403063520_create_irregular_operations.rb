class CreateIrregularOperations < ActiveRecord::Migration[5.0]
  def change
    create_table :irregular_operations do |t|
      t.date :date
      t.references :plan

      t.timestamps
    end
  end
end
