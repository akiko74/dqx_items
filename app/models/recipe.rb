class Recipe < ActiveRecord::Base
  attr_accessible :level, :name, :job_id, :ingredients_attributes
  belongs_to :job
  has_many :ingredients
  has_many :items, :through => :ingredients
  accepts_nested_attributes_for :ingredients, :reject_if => proc {|attributes| attributes['item_id'].blank?}, :allow_destroy => true

  validates :level,
    :presence     => true,
    :numericality => {
      :only_integer => true,
      :greater_than => 0
    }


end
