class AddYearToVisits < ActiveRecord::Migration
  def change
    add_column :visits, :year, :int

  end
end
