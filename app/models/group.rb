class Group < ActiveRecord::Base
  attr_accessible :title
  belongs_to :timetable
end
