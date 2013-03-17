class Recipe < ActiveRecord::Base
  attr_accessible :level, :name, :job_id, :usage_count, :ingredients_attributes
  belongs_to :job
  has_many :ingredients
  has_many :items, :through => :ingredients

  has_many :equipments, :dependent => :destroy
  has_many :users, :through => :equipments

  accepts_nested_attributes_for :ingredients, :reject_if => proc {|attributes| attributes['item_id'].blank?}, :allow_destroy => true

  validates :level,
    :presence     => true,
    :numericality => {
      :only_integer => true,
      :greater_than => 0
    }


end
