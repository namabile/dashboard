require 'gattica'
require "activerecord-import"

class GoogleAnalytics
	@ga = Gattica.new({
		:email => "",
		:password => ""
		})
	@rg_profile = 34968093
	@tickco_profile = 35305074

	def self.get_data(start_date, end_date)
		data = @ga.get({
			:start_date => start_date,
			:end_date => end_date,
			:metrics => ['visits', 'transactions', 'transactionRevenue'],
			:dimensions => ['medium', 'date']
		})
		data.to_hash
	end

	def self.get_order_source(start_date, end_date)
		data = @ga.get({
			:start_date => start_date,
			:end_date => end_date,
			:metrics => ['transactions'],
			:dimensions => ['transactionId', 'medium', 'source'],
			:max_results => 10000
		})
		data.to_hash
	end

	def self.update_orders_with_source
		start_date = (Date.today - 31.days).to_s			
		end_date = (Date.today - 1.day).to_s
		@ga.profile_id = @rg_profile	
		data = get_order_source(start_date, end_date)
		data.each do |item|
		 	orders = Order.find_all_by_order_id(item[:transactionId])
		 	if orders 
		 		orders.each do |order|
		 			order.update_attributes(:source => item[:source], :medium => item[:medium])
		 		end
		 	end
		end
		Update.post_update("order source/medium updated")
	end

	def self.update_visits
		last_entry = Visit.find_last_by_brand("Razorgator")
		start_date = (last_entry.date + 1.day).to_s
		end_date = (Date.today - 1.day).to_s
		
		["Razorgator", "TickCo"].each do |brand|
			if (brand == "Razorgator")
				@ga.profile_id = @rg_profile	
			else 
				@ga.profile_id = @tickco_profile
			end	
			data = get_data(start_date, end_date)
			parse_data(data, brand)
		end
		Update.post_update("visits updated")
	end

	def self.refresh_visits
		Visit.delete_all
		start_date = (Date.today - 31.days).to_s			
		end_date = (Date.today - 1.day).to_s
		["Razorgator", "TickCo"].each do |brand|
			if (brand == "Razorgator")
				@ga.profile_id = @rg_profile	
			else 
				@ga.profile_id = @tickco_profile
			end	
			data = get_data(start_date, end_date)
			parse_data(data, brand)
		end
		Update.post_update("visits refreshed")
	end
			
	def self.parse_data(data, brand)
		values = []
		columns = [ :brand, :date, :medium, :visits, :orders, :revenue ]
		data.each do |item|
			values.push([
				brand,
				item[:date],
				item[:medium],
				item[:visits],
				item[:orders],
				item[:transactionRevenue]
			])
		end
		Visit.import columns, values
	end

end