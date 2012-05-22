class Order < ActiveRecord::Base
	validates_uniqueness_of :purchase_id
	validates :order_id, :purchase_id, :ticket_revenue, presence: true
	scope :good, where(:cancelled => false)
	scope :mercury, where(:assigned_vendor_name => "Ticket Network Direct")

	def self.get_totals_by_group(group)
		select("#{group}, sum(ticket_revenue) as total_revenue, count(distinct order_id) as total_orders, sum(tickets) as total_tickets").group(group)
	end

	def self.order_date_between(start_date, end_date)
		end_date = start_date + 1.day if start_date == end_date
		where("order_date >= ? and order_date < ?", start_date, end_date)
	end
end
# == Schema Information
#
# Table name: orders
#
#  id              :integer         not null, primary key
#  order_id        :integer
#  purchase_id     :integer
#  ticket_revenue  :float
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  order_date      :datetime
#  order_type_name :string(255)
#  event_category  :string(255)
#  event_name      :string(255)
#  event_date      :datetime
#  tickets         :integer
#

