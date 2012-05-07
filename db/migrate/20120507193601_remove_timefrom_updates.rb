class RemoveTimefromUpdates < ActiveRecord::Migration
  def up
  	remove_column :updates, :time
  end

  def down
  end
end
