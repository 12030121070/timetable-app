class ClassroomLesson < ActiveRecord::Base
  attr_accessible :classroom_id

  belongs_to :classroom
  belongs_to :lesson
end
