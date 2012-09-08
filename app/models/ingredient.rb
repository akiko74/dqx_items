class Ingredient < ActiveRecord::Base
  attr_accessible :item_id, :recipe_id, :number
  belongs_to :item
  belongs_to :recipe
end
