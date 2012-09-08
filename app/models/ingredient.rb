class Ingredient < ActiveRecord::Base
  attr_accessible :item_id, :recipe_id
  belongs_to :item
  belongs_to :recipe
end
