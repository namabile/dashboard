require "rubygems"
require "rufus/scheduler"

scheduler = Rufus::Scheduler.start_new

scheduler.every '1m', :allow_overlapping => false, :blocking => true, :tags => "update orders" do
	DBTasks.get_orders(1)
	update = Update.find_last_by_update_type("orders updated")
	update.update_attribute(:updated_at, Time.now.to_s(:db)) unless update.nil?
	Update.create(update_type: "orders updated") if update.nil?
end

scheduler.cron '0 * * * *', :allow_overlapping => false, :tags => "refresh orders"  do
	DBTasks.get_orders()
	update = Update.find_last_by_update_type("orders refreshed")
	update.update_attribute(:updated_at, Time.now.to_s(:db)) unless update.nil?
	Update.create(update_type: "orders refreshed") if update.nil?
end