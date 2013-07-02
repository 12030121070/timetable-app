class User < ActiveRecord::Base
  attr_accessible :email, :password, :remember_me

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
end
