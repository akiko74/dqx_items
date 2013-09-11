class Category < ActiveRecord::Base
  attr_accessible :name, :kana
  has_many :eq_categories
  has_many :recipes, :through => :eq_categories
end
