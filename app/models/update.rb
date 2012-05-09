class Update < ActiveRecord::Base
	attr_accessible :update_type

	def self.post_update(type)
		return if type.nil? 
		update = Update.find_last_by_update_type(type)
		update.update_attribute(:updated_at, Time.now.to_s(:db)) unless update.nil?
		Update.create(update_type: type) if update.nil?
	end
end
# == Schema Information
#
# Table name: updates
#
#  id          :integer         not null, primary key
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  update_type :string(255)
#

