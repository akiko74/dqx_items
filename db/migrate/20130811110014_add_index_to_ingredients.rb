class AddIndexToIngredients < ActiveRecord::Migration
  def change
    add_index :ingredients, [:recipe_id,:item_id], unique:true
  end
end
