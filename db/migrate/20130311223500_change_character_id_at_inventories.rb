class ChangeCharacterIdAtInventories < ActiveRecord::Migration
  def change
    change_column :inventories, :user_id, :integer, :null => false
    change_column :inventories, :character_id, :integer, :null => false, :default => 0
  end
end
