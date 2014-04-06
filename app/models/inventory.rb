class Inventory < ActiveRecord::Base
  #attr_accessible :user_id, :item_id, :stock, :total_cost, :bazzar_cost

  belongs_to :user
  belongs_to :item
end
