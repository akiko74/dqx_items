class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
      t.integer :user_id
      t.integer :item_id
      t.integer :character_id
      t.integer :stock
      t.integer :average_cost
      t.integer :bazzar_cost

      t.timestamps
    end
  end
end
