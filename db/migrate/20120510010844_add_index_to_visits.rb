class AddIndexToVisits < ActiveRecord::Migration
  def change
    add_index :visits, :date

  end
end
