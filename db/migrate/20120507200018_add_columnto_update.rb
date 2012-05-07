class AddColumntoUpdate < ActiveRecord::Migration
  def up
  	add_column :updates, :update_type, :string
  	remove_column :updates, :type
  	add_index :updates, :update_type
  end

  def down
  end
end
