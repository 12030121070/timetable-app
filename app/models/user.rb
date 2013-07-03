class User < ActiveRecord::Base
  attr_accessible :email, :password, :remember_me

  normalize_attributes :email

  has_many :memberships, :dependent => :destroy
  has_many :organizations, :through => :memberships

  devise :database_authenticatable, :registerable, :recoverable,
    :rememberable, :trackable, :validatable, :confirmable

  after_create :activate_memberships

  private

  def activate_memberships
    Membership.inactive.where(:email => email).each { |membership|
      membership.update_attributes :user_id => id, :email => nil
    }
  end
end
