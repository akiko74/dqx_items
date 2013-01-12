class Item < ActiveRecord::Base
  attr_accessible :name, :price
  has_many :ingredients
  has_many :recipes, :through => :ingredients


  def to_s
    self.attributes.to_s
  end

  def jobs
    recipes.map(&:job).uniq
  end

end
