require "odbc"

class ReportsController < ApplicationController
	
	respond_to :js, :csv
	
	def event_ticket_report
		
	end

	def run_event_ticket_report
		start_date = Date.strptime(params[:start_date], "%m/%d/%Y").to_s
      	end_date = Date.strptime(params[:end_date], "%m/%d/%Y").to_s
		event_name = "%" + params[:event_name] + "%"
		conn = ODBC.connect("sql03mia")
		conn.timeout(60)
		file = File.new('\\\fap01lax\nick.amabile$\SQL Queries\event_ticket_report.sql', 'rb')
		sql = file.read.gsub("\n"," ").gsub("\t"," ").gsub("\r"," ")
		file.close
		if event_name.blank?
			sql.gsub("oe.Event_Name like ?","")
			results = conn.run(sql, start_date, end_date)
		else
			results = conn.run(sql, event_name, start_date, end_date)
		end
		@results_array = []
		results.fetch_hash do |row|
			@results_array.push({
				:event_name => row["Event_Name"],
				:event_category => row["event_category"],
				:performance_date => row["performance_date"].to_date,
				:performance_time => row["performance_time"].to_time,
				:participant1 => row["participant1"],
				:participant2 => row["participant2"],
				:venue_name => row["venue_name"],
				:city => row["city"],
				:state => row["state"],
				:url => row["URL"],
				:total_ticket_count => row["total_ticket_count"],
				:total_ticket_value => row["total_ticket_value"],
				:min_ticket_price => row["min_ticket_price"],
				:max_ticket_price => row["max_ticket_price"]
			})
		end
		respond_with @results_array
		results.drop
		conn.disconnect
	end

	def export_to_excel
		@results = JSON.parse(params[:results])
		headers["Content-Disposition"] = "attachment; filename=ticket_inventory_by_event_#{Time.now.to_i}.csv"
		render :layout => false
	end

	def spiff_report
		
	end

	def run_spiff_report
		goal = params[:weekly_goal]
		@week_end_date = Date.today + (5 - Date.today.wday).days
		@week_start_date = @week_end_date - 6.days

		order_types = ["RZG - Phone", "TickCo - Phone"]
		orders = Order.good.order_date_between(@week_start_date, @week_end_date + 1.day).where(:order_type_name => order_types)
		@orders_by_type = orders.get_totals_by_group("order_type_name")

		@orders_by_type_totals = {}
		@orders_by_type_totals[:total_revenue] = orders.sum(:ticket_revenue)
		@orders_by_type_totals[:total_orders] = orders.count(:order_id, :distinct => true)
		@orders_by_type_totals[:total_tickets] = orders.sum(:tickets)
		
		agents = ["Blake.Dirickson","bridget.eldred","emma.perez","john.dunn","ryan.galovan"]
		new_orders = Order.good.order_date_between(@week_start_date, @week_end_date + 1.day).where(:order_type_name => order_types, :agent => agents)
		
		@orders_by_agent = new_orders.get_totals_by_group("agent")
		
		@orders_by_agent_totals = {}
		@orders_by_agent_totals[:total_revenue] = new_orders.sum(:ticket_revenue)
		@orders_by_agent_totals[:total_orders] = new_orders.count(:order_id, :distinct => true)
		@orders_by_agent_totals[:total_tickets] = new_orders.sum(:tickets)
		
		@pct_of_goal = @orders_by_type_totals[:total_revenue].to_f / goal.to_f * 100
		@agents = agents.map { |x| x.gsub("."," ").partition(" ").map {|y| y.capitalize}.join }
		@last_update = Update.find_last_by_update_type("orders updated")
		debugger
	end
end
