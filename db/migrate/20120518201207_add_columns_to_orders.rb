class AddColumnsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :agent, :string

    add_column :orders, :requested_vendor_name, :string

    add_column :orders, :assigned_vendor_name, :string

    add_column :orders, :requested_vendor_type_name, :string

    add_column :orders, :assigned_vendor_type_name, :string

    add_column :orders, :cancelled, :int

  end
end
