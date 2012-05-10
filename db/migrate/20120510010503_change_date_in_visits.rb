class ChangeDateInVisits < ActiveRecord::Migration
  def up
  	change_column :visits, :date, :date
  end

  def down
  end
end
