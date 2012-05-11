require "rubygems"
require "rufus/scheduler"

scheduler = Rufus::Scheduler.start_new

scheduler.every '1m', :allow_overlapping => false, :blocking => true, :tags => "update orders" do
	DBTasks.update_orders
end

scheduler.cron '0 0 * * *', :allow_overlapping => false, :tags => "refresh orders"  do
	DBTasks.refresh_orders
end

scheduler.cron '30 0 * * *', :allow_overlapping => false, :tags => "update visits"  do
	GoogleAnalytics.update_visits
end