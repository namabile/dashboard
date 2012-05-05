require 'odbc'
require 'rubygems'
require "rufus/scheduler"

class DBTasks

	def self.get_orders(update = 0)
		# get orders_ids for the last 30 days
		conn = ODBC.connect("sql03mia")
		file = File.new('\\\fap01lax\nick.amabile$\SQL Queries\revenue_report.sql', 'rb')
		
		if (update == 1)
			start_date = Date.today.to_s
			end_date = (Date.today + 1.day).to_s
			min_order_id = Order.order("order_id desc").first[:order_id]
		else
			end_date = (Date.today + 1.day).to_s
			start_date = (Date.today - 31.days).to_s
			min_order_id = 1
		end
		sql = file.read.gsub("\n"," ").gsub("\t"," ").gsub("\r"," ")
		results = conn.run(sql, start_date, end_date, min_order_id)
		results.fetch_hash do |row|
			order = Order.new(
				order_id: row["order_id"], 
				purchase_id: row["purchase_id"],
				ticket_revenue: row["ticket_revenue"],
				order_date: row["orderdate"].to_s,
				order_type_name: row["ordertypename"],
				event_category: row["event_category"],
				event_name: row["event_name"],
				event_date: row["event_date"].to_s,
				tickets: row["tickets"])
			order.save
		end
		conn.disconnect
		results.drop
	end
end
