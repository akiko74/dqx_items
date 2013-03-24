class Equipment < ActiveRecord::Base
  attr_accessible :user_id, :recipe_id, :cost, :renkin_count

  belongs_to :user
  belongs_to :recipe

  def self.registered(equipment, recipe_id)
    self.where("recipe_id = ? AND renkin_count = ? AND cost = ?", recipe_id, equipment[:renkin_count], equipment[:cost]).first
  end

  def register(equipment, recipe, user_id)
    self.create(:user_id => user_id, :recipe_id => recipe.id, :renkin_count => equipment[:renkin_count], :cost => equipment[:cost])
  end
end
