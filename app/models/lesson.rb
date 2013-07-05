class Lesson < ActiveRecord::Base
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

  extend Enumerize
  enumerize :kind, in: [:lecture, :practice, :laboratory, :research, :design, :exam, :test], predicates: true

  accepts_nested_attributes_for :classroom_lessons, :allow_destroy => true
  accepts_nested_attributes_for :group_lessons, :allow_destroy => true
  accepts_nested_attributes_for :lecturer_lessons, :allow_destroy => true
end
