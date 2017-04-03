class CreateDefualtOperatins < ActiveRecord::Migration[5.0]
  def change
    create_table :defualt_operatins do |t|
      t.integer :week_day
      t.references :plan
      t.timestamps
    end
  end
end
