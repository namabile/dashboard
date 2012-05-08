class Update < ActiveRecord::Base
	attr_accessible :update_type
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

