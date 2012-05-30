if Rails.env.production?
	require "rubygems"
	require "rufus/scheduler"

	scheduler = Rufus::Scheduler.start_new

	scheduler.every '1m', :allow_overlapping => false, :blocking => true, :tags => "update orders" do
		DBTasks.update_orders
	end

	scheduler.every '10m', :allow_overlapping => false, :blocking => true, :tags => "refresh today's orders" do
		DBTasks.refresh_todays_orders
	end

	scheduler.cron '0 0 * * *', :allow_overlapping => false, :blocking => true, :tags => "refresh orders"  do
		DBTasks.refresh_orders
	end

	scheduler.cron '15 0 * * *', :allow_overlapping => false, :blocking => true, :tags => "update visits"  do
		GoogleAnalytics.update_visits
	end

	scheduler.cron '30 0 * * *', :allow_overlapping => false, :blocking => true, :tags => "update last year's orders"  do
		DBTasks.update_last_years_orders
	end
end