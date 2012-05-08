require 'odbc'
require 'activerecord-import'

class DBTasks

	def self.get_orders(update = 0)
		# get orders_ids for the last 30 days
		conn = ODBC.connect("sql03mia")
		conn.timeout(60)
		file = File.new('\\\fap01lax\nick.amabile$\SQL Queries\revenue_report.sql', 'rb')
		sql = file.read.gsub("\n"," ").gsub("\t"," ").gsub("\r"," ")
		file.close
		if (update == 1)
			start_date = Date.today.to_s
			end_date = (Date.today + 1.day).to_s
			min_order_id = Order.select("order_id").limit(1).order("order_id desc").first.order_id
		else
			end_date = (Date.today + 1.day).to_s
			start_date = (Date.today - 31.days).to_s
			min_order_id = ''
		end
		results = conn.run(sql, start_date, end_date)
		puts results
		columns = [ :order_id, :purchase_id, :ticket_revenue, :order_date, :order_type_name, :event_category, :event_name, :event_date, :tickets ]
		values = []
		results.fetch_hash do |row|
			values.push([
				row["order_id"], 
				row["purchase_id"],
				row["ticket_revenue"],
				row["orderdate"].to_s,
				row["ordertypename"],
				row["event_category"],
				row["event_name"],
				row["event_date"].to_s,
				row["tickets"]])
		end
		Order.import columns, values, :validate => true
		results.drop
		conn.disconnect
	end
end