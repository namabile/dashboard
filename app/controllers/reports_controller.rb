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
				:performance_date => row["performance_date"],
				:performance_time => row["performance_time"],
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
		headers["Content-Disposition"] = "attachment; filename=ticket_inventory_by_event.csv"
		render :layout => false
		# respond_with @results

	end
end
