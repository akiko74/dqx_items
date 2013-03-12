class AddUsageToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :usage_count, :integer, :default => 1, :null => false
  end
end
