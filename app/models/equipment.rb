class Equipment < ActiveRecord::Base
  attr_accessible :user_id, :recipe_id, :cost, :renkin_count

  belongs_to :user
  belongs_to :recipe

end
