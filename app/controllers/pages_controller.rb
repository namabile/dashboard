class PagesController < ApplicationController
  respond_to :js

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
  	orders = Order.where("order_date >= ? and order_date < ?", Date.today, Date.today + 1).order("order_id desc")
  	@last_update = Update.find_last_by_update_type("orders updated")

  	offset = (0..6).to_a[Date.today.wday - Date.today.years_ago(1).wday]
  	@today_last_year = Date.today.years_ago(1) + offset.days

  	last_years_orders = Order.where("order_date >= ? and order_date < ?", @today_last_year, @today_last_year + 1.day)
  	last_years_orders_by_type = last_years_orders.select("order_type_name, sum(ticket_revenue) as total_revenue, count(distinct order_id) as total_orders, sum(tickets) as total_tickets").group("order_type_name")
  	@last_year = {}
  	last_years_orders_by_type.each do |type|
  		@last_year[type[:order_type_name]] = {}
  		@last_year[type[:order_type_name]][:total_revenue] = type[:total_revenue]
  		@last_year[type[:order_type_name]][:total_orders] = type[:total_orders]
  		@last_year[type[:order_type_name]][:total_tickets] = type[:total_tickets]
  	end

  	this_years_orders_by_type = orders.select("order_type_name, sum(ticket_revenue) as total_revenue, count(distinct order_id) as total_orders, sum(tickets) as total_tickets").group("order_type_name")
	  @this_year = {}
	  this_years_orders_by_type.each do |type|
  		@this_year[type[:order_type_name]] = {}
  		@this_year[type[:order_type_name]][:total_revenue] = type[:total_revenue]
  		@this_year[type[:order_type_name]][:total_orders] = type[:total_orders]
  		@this_year[type[:order_type_name]][:total_tickets] = type[:total_tickets]
  	end  	
    @all_channels = ["RZG - Web", "RZG - Phone", "TickCo - Web", "TickCo - Phone", "Circles", "TicketOs"]

    # get total row
    @last_year_totals = {}
    @last_year_totals[:total_revenue] = last_years_orders.sum(:ticket_revenue)
    @last_year_totals[:total_orders] = last_years_orders.count(:order_id, distinct: true)
    @last_year_totals[:total_tickets] = last_years_orders.sum(:tickets)

    @this_year_totals = {}
    @this_year_totals[:total_revenue] = orders.sum(:ticket_revenue)
    @this_year_totals[:total_orders] = orders.count(:order_id, distinct: true)
    @this_year_totals[:total_tickets] = orders.sum(:tickets)
  # debugger
  end

  def total_orders

  end


  def get_total_orders
    if params[:start_date] < params[:end_date]
      start_date = Date.strptime(params[:start_date], "%m/%d/%Y")
      end_date = Date.strptime(params[:end_date], "%m/%d/%Y")
    elsif params[:start_date] == params[:end_date]
      start_date = Date.strptime(params[:start_date], "%m/%d/%Y")
      end_date = Date.strptime(params[:end_date], "%m/%d/%Y") + 1.day
    elsif params[:start_date] > params[:end_date]
      start_date = Date.strptime(params[:end_date], "%m/%d/%Y")
      end_date = Date.strptime(params[:start_date], "%m/%d/%Y")
    end

    @total_orders = Order.select("sum(ticket_revenue) as total_revenue").where("order_date >= ? and order_date < ?", start_date, end_date)
    respond_with @total_orders
  end

end