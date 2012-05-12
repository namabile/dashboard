class Date
	def self.today_last_year
		today_last_year = self.years_ago(1)
		offset = self.wday - today_last_year.wday
		return today_last_year + offset
	end

	def week_ending

	end

end