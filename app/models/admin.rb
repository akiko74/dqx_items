class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  #devise :database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :trackable, :validatable, :timeoutable, :lockable
  devise :database_authenticatable, :rememberable, :timeoutable, :validatable

  #attr_accessible :email, :password, :password_confirmation, :remember_me
end
