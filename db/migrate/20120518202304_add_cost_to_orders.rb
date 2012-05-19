class AddCostToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :assigned_ticket_cost, :float

  end
end
