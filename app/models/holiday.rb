class Holiday < ActiveRecord::Base
  attr_accessible :date
  scope :sorted, ->(t){ order('date ASC') }
end
