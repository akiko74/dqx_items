class CreateMytools < ActiveRecord::Migration
  def change
    create_table :mytools do |t|
      t.integer :character_id
      t.integer :tool_id
      t.integer :cost
      t.integer :bazzar_cost

      t.timestamps
    end
  end
end
