# encoding: utf-8

class Classroom < ActiveRecord::Base
  include TableForWeek
  include WeekTimetable
  include WithBusy

  attr_accessible :number

  belongs_to :building

  has_many :classroom_lessons, :dependent => :destroy

  has_many :days,    :through => :lessons
  has_many :lessons, :through => :classroom_lessons
  has_many :timetables, :through => :lessons, :uniq => true
  has_many :weeks,   :through => :days, :uniq => true, :order => 'weeks.starts_on'

  validates_presence_of :number
  validates_uniqueness_of :number, :scope => :building_id

  normalize_attributes :number

  with_busy :method => :to_s, :message => 'уже занята в это время'

  delegate :organization, :to => :building

  def to_s
    "#{number} (#{building})"
  end
end
