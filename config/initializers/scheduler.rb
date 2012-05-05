require "rubygems"
require "rufus/scheduler"

scheduler = Rufus::Scheduler.start_new

scheduler.every '1m', :allow_overlapping => false, :tags => "update orders" do
	puts "updating orders"
	DBTasks.get_orders(1)
	puts "orders updated"
end

scheduler.cron '0 0 * * *', :blocking => true, :tags => "refresh orders"  do
	puts "refreshing orders"
	DBTasks.get_orders()
	puts "orders refreshed"
end