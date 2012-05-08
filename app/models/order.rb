class Order < ActiveRecord::Base
	validates :purchase_id, :uniqueness => true
	validates :order_id, :purchase_id, :ticket_revenue, presence: true
end