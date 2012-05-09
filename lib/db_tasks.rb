require 'odbc'
require 'activerecord-import'

class DBTasks

	def self.update_orders
		start_date = Date.today.to_s
		end_date = (Date.today + 1.day).to_s
		min_order_id = Order.select("order_id").limit(1).order("order_id desc").first.order_id	
		run_revenue_query(start_date, end_date, min_order_id)
	end

	def self.refresh_orders
		end_date = (Date.today + 1.day).to_s
		start_date = (Date.today - 31.days).to_s
		run_revenue_query(start_date, end_date)
	end

	def self.get_last_years_orders
		today_last_year = Date.today.years_ago(1)
		offset = Date.today.wday - today_last_year.wday
		start_date = (today_last_year + offset.days).to_s
		end_date = (start_date.to_date - 31.days).to_s
		run_revenue_query(start_date, end_date)
	end

	private
		def self.run_revenue_query(start_date, end_date, min_order_id = nil)
			conn = ODBC.connect("sql03mia")
			conn.timeout(60)
			file = File.new('\\\fap01lax\nick.amabile$\SQL Queries\revenue_report.sql', 'rb')
			sql = file.read.gsub("\n"," ").gsub("\t"," ").gsub("\r"," ")
			file.close
			min_order_id = '' if min_order_id.nil?
			results = conn.run(sql, start_date, end_date, min_order_id)
			columns = [ :order_id, :purchase_id, :ticket_revenue, :order_date, :order_type_name, :event_category, :event_name, :event_date, :tickets, :order_year ]
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
					row["tickets"],
					row["orderdate"].year])
			end
			Order.import columns, values, :validate => true
			results.drop
			conn.disconnect
		end
end