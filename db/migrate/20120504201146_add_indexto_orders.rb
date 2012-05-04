class AddIndextoOrders < ActiveRecord::Migration
  def up
  	add_index :orders, :order_id
  	add_index :orders, :order_date

  end

  def down
  end
end
