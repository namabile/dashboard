class FixYearinOrders < ActiveRecord::Migration
  def up
  	remove_column :orders, :year
  	add_column :orders, :order_year, :int
  end

  def down
  end
end
