class AddKanaToRecipe < ActiveRecord::Migration
  def change
    add_column :recipes, :kana, :string
  end
end
