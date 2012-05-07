class CreateUpdates < ActiveRecord::Migration
  def change
    create_table :updates do |t|
      t.string :type
      t.datetime :time
      t.timestamps
    end
  end
end
