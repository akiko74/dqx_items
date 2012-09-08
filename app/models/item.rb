class Item < ActiveRecord::Base
  attr_accessible :name
  has_many :ingredients
  has_many :recipes, :through => :ingredients

  def jobs
    recipes.map(&:job).uniq
  end

end
