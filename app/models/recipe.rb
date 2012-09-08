class Recipe < ActiveRecord::Base
  attr_accessible :level, :name, :job_id
  belongs_to :job
  has_many :ingredients
  has_many :items, :through => :ingredients
end
