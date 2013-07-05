class Lesson < ActiveRecord::Base
  attr_accessible :kind

  belongs_to :day
  belongs_to :discipline
  belongs_to :lesson_time
end
