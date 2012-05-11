class AddMediumToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :medium, :string
    add_column :orders, :source, :string
  end
end
