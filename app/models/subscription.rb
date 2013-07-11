class Subscription < ActiveRecord::Base
  attr_accessible :ends_on, :groups_count, :start_on
  belongs_to :organization
end
