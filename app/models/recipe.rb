class Recipe < ActiveRecord::Base
  attr_accessible :level, :name, :job_id, :usage_count, :kana, :ingredients_attributes, :category_ids
  belongs_to :job
  has_many :ingredients
  has_many :items, :through => :ingredients

  has_many :equipments, :dependent => :destroy
  has_many :users, :through => :equipments

  has_many :eq_categories
  has_many :categories, :through => :eq_categories

  accepts_nested_attributes_for :ingredients, :reject_if => proc {|attributes| attributes['item_id'].blank?}, :allow_destroy => true

  validates :level,
    :presence     => true,
    :numericality => {
      :only_integer => true,
      :greater_than => 0
    }


  def to_dictionary_hash
    {
      name: name,
      kana: kana,
      category: categories.map(&:name),
      type: 'recipe'
    }
  end


end
