class Holiday < ActiveRecord::Base
  attr_accessible :date, :title
  scope :sorted, ->(t){ order('date ASC') }
end
