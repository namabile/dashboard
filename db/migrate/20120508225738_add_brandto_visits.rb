class AddBrandtoVisits < ActiveRecord::Migration
  def up
  	add_column :visits, :brand, :string
  end

  def down
  end
end
