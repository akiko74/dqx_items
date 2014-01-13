class AddIndexToJob < ActiveRecord::Migration
  def change
    add_index :jobs, [:name], unique:true
  end
end
