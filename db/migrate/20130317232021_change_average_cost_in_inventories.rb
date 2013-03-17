class ChangeAverageCostInInventories < ActiveRecord::Migration
  def change
    rename_column :inventories, :average_cost, :total_cost
  end
end
