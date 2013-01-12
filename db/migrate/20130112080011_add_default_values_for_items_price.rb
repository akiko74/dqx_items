class AddDefaultValuesForItemsPrice < ActiveRecord::Migration
  def up
    remove_column :items, :price
    add_column :items, :price, :integer, :default => 0
    Item.update_all ["price = ?",0]
  end

  def down
    add_column :items, :price, :integer
  end
end
