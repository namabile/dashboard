class PagesController < ApplicationController
  require 'db_tasks'
  def home
  	@orders = Order.where("order_date >= ? and order_date < ?", Date.today, Date.today + 1).order("order_id desc")
  	@total_dollars = @orders.sum(:ticket_revenue)
  	@total_orders = @orders.count(:order_id, distinct: true)
  	@total_tickets = @orders.sum(:tickets)
  	@last_update = Update.find_last_by_update_type("orders updated")
  end

  def visits
  	@last_30_days = Visit.where("date >= ? and date < ?", Date.today - 30.days, Date.today)
  	@total_visits = @last_30_days.sum(:visits)
  end
  
end