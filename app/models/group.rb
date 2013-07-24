class Group < ActiveRecord::Base
  attr_accessible :title

  belongs_to :timetable

  has_many :group_lessons, :dependent => :destroy
  has_many :lessons, :through => :group_lessons

  validates_presence_of :title
  validates_uniqueness_of :title, :scope => :timetable_id
end
