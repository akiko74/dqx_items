class AddBazzarToItem < ActiveRecord::Migration
  def change
    add_column :items, :bazzar_price, :integer
  end
end
