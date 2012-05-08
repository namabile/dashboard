class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.datetime :date
      t.string :medium
      t.integer :visits
      t.integer :orders
      t.float :revenue

      t.timestamps
    end
  end
end
