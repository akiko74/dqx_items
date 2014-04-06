class Character < ActiveRecord::Base
  #attr_accessible :user_id, :char_name

  has_many :mytools
end
