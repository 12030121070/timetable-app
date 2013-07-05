class LecturerLesson < ActiveRecord::Base
  attr_accessible :lecturer_id

  belongs_to :lesson
  belongs_to :lecturer
end
