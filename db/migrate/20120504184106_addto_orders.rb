class AddtoOrders < ActiveRecord::Migration
  def up
	add_column :orders, :order_date, :date
	add_column :orders, :order_type_name, :string
	add_column :orders, :event_category, :string
	add_column :orders, :event_name, :string
	add_column :orders, :event_date, :date
	add_column :orders, :tickets, :int
  end

  def down
  end
end
