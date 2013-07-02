class Membership < ActiveRecord::Base
  extend Enumerize

  attr_accessible :role, :user_id

  belongs_to :user
  belongs_to :organization

  validates_presence_of :role
  validates_uniqueness_of :role, :scope => [:user_id, :organization_id]

  enumerize :role, :in => [:admin, :member]
end
