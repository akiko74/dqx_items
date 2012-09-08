class AddNumberToIngredients < ActiveRecord::Migration
  def change
    add_column :ingredients, :number, :integer
  end
end
