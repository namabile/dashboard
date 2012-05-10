class Visit < ActiveRecord::Base
	validates_unqiueness_of :date, :scope => [:brand, :medium]
end

# == Schema Information
#
# Table name: visits
#
#  id         :integer         not null, primary key
#  date       :datetime
#  medium     :string(255)
#  visits     :integer
#  orders     :integer
#  revenue    :float
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

