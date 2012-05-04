class ChangeOrders < ActiveRecord::Migration
  def up
  	change_column :orders, :order_date, :datetime
  	change_column :orders, :event_date, :datetime
  end

  def down
  end
end
