class Group < ActiveRecord::Base
  attr_accessible :title
  belongs_to :timetable

  validates_uniqueness_of :title
end
