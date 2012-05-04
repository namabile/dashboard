class PagesController < ApplicationController
  require 'db_tasks'
  def home
  	@orders = Order.where("order_date >= ? and order_date < ?", Date.today, Date.today + 1).order("order_id desc")
  	@total_orders = @orders.sum(:ticket_revenue)
  	@last_order_time = @orders.first[:updated_at].localtime.strftime("%l:%M %p")
  end
end