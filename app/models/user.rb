class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :characters_attributes
  # attr_accessible :title, :body
  #
  has_many :items, :through => :inventories
  has_many :characters

  accepts_nested_attributes_for :characters

  def with_character
    Array.new(5) {self.characters.build}
    self
  end
end
