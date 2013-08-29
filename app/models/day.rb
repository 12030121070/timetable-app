class Day < ActiveRecord::Base
  extend Enumerize

  attr_accessible :date, :status

  belongs_to :week

  has_many :lessons, :dependent => :destroy

  enumerize :status, in: [:workday, :weekend, :holiday], predicates: true

  delegate :timetable, :organization, :to => :week
  delegate :cwday, :wday,             :to => :date

  normalize_attributes :status

  before_create :set_status

  def today?
    date == Date.today
  end

  # TODO: rename to name
  def day_name
    I18n.l date, :format => '%a'
  end

  def has_lesson_at?(lesson_time)
    timetable.lesson_times.joins(:lessons).include? lesson_time
  end

  def lesson_times
    timetable.lesson_times.for_day(cwday)
  end

  def set_status
    self.status = :holiday if organization.holidays.map(&:date).include?(self.date)
  end
end
