class Membership < ActiveRecord::Base
  extend Enumerize

  attr_accessible :role, :user_id, :email

  belongs_to :user
  belongs_to :organization

  validates_presence_of :role
  #validates_uniqueness_of :role, :scope => [:user_id, :email, :organization_id]

  enumerize :role, :in => [:admin, :member]

  def activated?
    user_id?
  end
end
