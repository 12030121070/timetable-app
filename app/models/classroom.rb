# encoding: utf-8

class Classroom < ActiveRecord::Base
  include WeekTimetable

  attr_accessible :number

  belongs_to :building

  has_many :classroom_lessons, :dependent => :destroy
  has_many :lessons, :through => :classroom_lessons

  validates_presence_of :number
  validates_uniqueness_of :number, :scope => :building_id

  normalize_attributes :number

  delegate :organization, :to => :building

  def to_s
    "#{number} (#{building})"
  end
end
