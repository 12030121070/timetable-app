class ClassroomLesson < ActiveRecord::Base
  belongs_to :classroom
  belongs_to :lesson
end
