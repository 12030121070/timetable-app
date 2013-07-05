class LecturerLesson < ActiveRecord::Base
  belongs_to :lesson
  belongs_to :lecturer
end
