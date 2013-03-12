class Item < ActiveRecord::Base
  attr_accessible :name, :price, :kana
  has_many :ingredients
  has_many :recipes, :through => :ingredients
  has_many :inventories
  has_many :users, :through => :inventories


  def to_s
    self.attributes.to_s
  end

  def jobs
    recipes.map(&:job).uniq
  end

end
