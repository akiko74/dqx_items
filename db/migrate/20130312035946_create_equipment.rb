class CreateEquipment < ActiveRecord::Migration
  def change
    create_table :equipment do |t|
      t.integer :user_id, :null => false
      t.integer :recipe_id, :null => false
      t.integer :cost, :default => 0
      t.integer :renkin_count, :default => 0

      t.timestamps
    end
  end
end
