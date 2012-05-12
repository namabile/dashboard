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

  def year_over_year
  	@orders = Order.where("order_date >= ? and order_date < ?", Date.today, Date.today + 1).order("order_id desc")
  	@last_update = Update.find_last_by_update_type("orders updated")

  	today_last_year = Date.today.years_ago(1)
  	offset = Date.today.wday - today_last_year.wday
  	@today_last_year = today_last_year + offset.days

  	@last_years_orders = Order.where("order_date >= ? and order_date < ?", @today_last_year, @today_last_year + 1.day)
  	last_years_orders_by_type = @last_years_orders.select("order_type_name, sum(ticket_revenue) as total_revenue, count(distinct order_id) as total_orders, sum(tickets) as total_tickets").group("order_type_name")
  	@last_year = {}
  	last_years_orders_by_type.each do |type|
  		@last_year[type[:order_type_name]] = {}
  		@last_year[type[:order_type_name]][:total_revenue] = type[:total_revenue]
  		@last_year[type[:order_type_name]][:total_orders] = type[:total_orders]
  		@last_year[type[:order_type_name]][:total_tickets] = type[:total_tickets]
  	end

  	this_years_orders_by_type = @orders.select("order_type_name, sum(ticket_revenue) as total_revenue, count(distinct order_id) as total_orders, sum(tickets) as total_tickets").group("order_type_name")
	  @this_year = {}
	  this_years_orders_by_type.each do |type|
  		@this_year[type[:order_type_name]] = {}
  		@this_year[type[:order_type_name]][:total_revenue] = type[:total_revenue]
  		@this_year[type[:order_type_name]][:total_orders] = type[:total_orders]
  		@this_year[type[:order_type_name]][:total_tickets] = type[:total_tickets]
  	end  	
    @all_channels = ["RZG - Web", "RZG - Phone", "TickCo - Web", "TickCo - Phone", "Circles", "TicketOs"]
  # debugger
  end

end