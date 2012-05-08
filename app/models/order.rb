class Order < ActiveRecord::Base
	validates :purchase_id, :uniqueness => true
	validates :order_id, :purchase_id, :ticket_revenue, presence: true
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

