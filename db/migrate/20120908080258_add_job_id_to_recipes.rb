class AddJobIdToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :job_id, :integer
  end
end
