class EqCategory < ActiveRecord::Base
  #attr_accessible :recipe_id, :category_id
  belongs_to :recipe
  belongs_to :category
end
