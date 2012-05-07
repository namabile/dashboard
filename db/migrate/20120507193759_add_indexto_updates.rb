class AddIndextoUpdates < ActiveRecord::Migration
  def up
  	add_index :updates, :type
  	add_index :updates, :created_at
  end

  def down
  end
end
