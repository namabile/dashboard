class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :order_id
      t.integer :purchase_id
      t.float :ticket_revenue
      t.timestamps
    end
  end
end
