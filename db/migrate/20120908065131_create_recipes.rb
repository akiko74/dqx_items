class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string  :name
      t.integer :level

      t.timestamps
    end
  end
end
