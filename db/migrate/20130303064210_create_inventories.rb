class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
      t.integer :user_id, :null => 0
      t.integer :item_id, :null => 0
      t.integer :stock, :default => 0
      t.integer :average_cost, :default => 0

      t.timestamps
    end
  end
end
