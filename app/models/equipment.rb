class Equipment < ActiveRecord::Base
  attr_accessible :user_id, :recipe_id, :cost, :renkin_count

  belongs_to :user
  belongs_to :recipe

  def self.registered(equipment, user_id)
    self.where("recipe_id = ? AND renkin_count = ? AND cost = ? AND user_id = ?", equipment[:recipe_id], equipment[:renkin_count], equipment[:cost], user_id)
  end

end
