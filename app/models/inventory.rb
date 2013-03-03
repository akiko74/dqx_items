class Inventory < ActiveRecord::Base
  attr_accessible :user_id, :item_id, :character_id, :stock, :average_cost, :bazzar_cost
  belongs_to :user
end
