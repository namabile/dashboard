require 'odbc'
require 'activerecord-import'

class DBTasks
	def self.refresh_all_orders
		DBTasks.refresh_orders
		DBTasks.refresh_last_years_orders
	end

	def self.update_orders
		start_date = Date.today.to_s
		end_date = (Date.today + 1.day).to_s
		run_revenue_query(start_date, end_date)
		Update.post_update("orders updated")
	end

	def self.refresh_todays_orders
		start_date = Date.today.to_s
		end_date = (Date.today + 1.day).to_s
		Order.delete_all.order_date_between(start_date, end_date)
		run_revenue_query(start_date, end_date)
		Update.post_update("todays orders refreshed")
	end

	def self.refresh_orders
		Order.delete_all("order_year = #{Date.today.year}")
		end_date = (Date.today + 1.day).to_s
		start_date = (Date.today - 31.days).to_s
		run_revenue_query(start_date, end_date)
		Update.post_update("orders refreshed")
	end

	def self.refresh_last_years_orders
		Order.delete_all("order_year = #{Date.today.prev_year.year}")
		offset = (0..6).to_a[Date.today.wday - Date.today.years_ago(1).wday]
		end_date = (Date.today.years_ago(1) + offset.days + 1.day ).to_s
		start_date = (end_date.to_date - 31.days).to_s
		run_revenue_query(start_date, end_date)
		Update.post_update("last year's orders refreshed")
	end

	def self.update_last_years_orders
		start_date = Order.find_by_order_year(2011, :order => "order_id desc")[:order_date].to_date + 1.day
		end_date = start_date + 1.day
		run_revenue_query(start_date.to_s, end_date.to_s)
		Update.post_update("last year's orders updated")
	end

	private
		def self.run_revenue_query(start_date, end_date)
			conn = ODBC.connect("sql03mia")
			conn.timeout(60)
			file = File.new('\\\fap01lax\nick.amabile$\SQL Queries\revenue_report_v2.sql', 'rb')
			sql = file.read.gsub("\n"," ").gsub("\t"," ").gsub("\r"," ")
			file.close
			results = conn.run(sql, start_date, end_date)
			columns = [ :order_id, :purchase_id, :ticket_revenue, :order_date, :order_type_name, :event_category, :event_name, :event_date, :tickets, :order_year, 
				:agent, :requested_vendor_name, :assigned_vendor_name, :requested_vendor_type_name, :assigned_vendor_type_name, :cancelled, :assigned_ticket_cost]
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
					row["orderdate"].year,
					row["agent"],
					row["requested_vendor_name"],
					row["assigned_vendor_name"],
					row["requested_vendor_type_name"],
					row["assigned_vendor_type_name"],
					row["cancelled"],
					row["assigned_ticket_cost"]])
			end
			# debugger
			Order.import columns, values, :validate => true
			results.drop
			conn.disconnect
		end

end