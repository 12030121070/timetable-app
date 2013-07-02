class Membership < ActiveRecord::Base
  attr_accessible :role, :user

  belongs_to :user
  belongs_to :organization
end
