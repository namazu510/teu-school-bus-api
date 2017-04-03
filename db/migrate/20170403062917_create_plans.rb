class CreatePlans < ActiveRecord::Migration[5.0]
  def change
    create_table :plans do |t|
      t.integer :from
      t.integer :to
      t.text :source_url

      t.timestamps
    end
  end
end
