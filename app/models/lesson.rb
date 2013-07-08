class Lesson < ActiveRecord::Base
  extend Enumerize

  attr_accessible :kind, :lesson_time_id, :discipline_id, :classroom_lessons_attributes, :lecturer_lessons_attributes, :group_lessons_attributes

  belongs_to :day
  belongs_to :discipline
  belongs_to :lesson_time

  has_many :classroom_lessons, :dependent => :destroy
  has_many :classrooms, :through => :classroom_lessons

  has_many :group_lessons, :dependent => :destroy
  has_many :groups, :through => :group_lessons

  has_many :lecturer_lessons, :dependent => :destroy
  has_many :lecturers, :through => :lecturer_lessons

  accepts_nested_attributes_for :classroom_lessons, :allow_destroy => true
  accepts_nested_attributes_for :group_lessons, :allow_destroy => true
  accepts_nested_attributes_for :lecturer_lessons, :allow_destroy => true

  enumerize :kind, in: [:lecture, :practice, :laboratory, :research, :design, :exam, :test], predicates: true

  def valid_classrooms?
    !self.class.joins(:lesson_time).where('lesson_times.id' => lesson_time.id).
      joins(:classrooms).where('classrooms.id' => classrooms.pluck(:id)).many?
  end

  def valid_lecturers?
    !self.class.joins(:lesson_time).where('lesson_times.id' => lesson_time.id).
      joins(:lecturers).where('lecturers.id' => lecturers.pluck(:id)).many?
  end

  def validation_message
    message = ''
    message << lecturers.map(&:full_name).join(', ') unless valid_lecturers?
    message << classrooms.map(&:to_s).join(', ') unless valid_classrooms?

    message.blank? ? nil : message
  end

  def valid_loading?
    self.class.joins(:lesson_time).where('lesson_times.id' => lesson_time.id).
      joins(:classroom_lessons).where('classroom_lessons.classroom_id' => classrooms.pluck(:id)).
      joins(:lecturer_lessons).where('lecturer_lessons.lecturer_id' => lecturers.pluck(:id)).one?
  end
end
