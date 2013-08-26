class Timetable < ActiveRecord::Base
  extend Enumerize

  attr_accessible :ends_on, :parity, :starts_on, :title, :first_week_parity,
    :lesson_times_attributes

  belongs_to :organization

  has_many :groups, :dependent => :destroy, :order => 'groups.title ASC'
  has_many :lesson_times, :as => :context, :dependent => :destroy, :order => 'day ASC, number ASC'
  has_many :weeks, dependent: :destroy, :order => 'number ASC'
  has_many :lessons, :through => :lesson_times
  has_many :lecturers, :through => :lessons, :uniq => true

  validates_presence_of :title, :starts_on, :ends_on
  validates_presence_of :first_week_parity, :if => :parity?

  accepts_nested_attributes_for :lesson_times, :allow_destroy => true

  after_initialize :initialize_lesson_times, :if => ->(timetable) { timetable.new_record? && timetable.lesson_times.empty? }
  after_create :create_weeks

  delegate :organization_holidays, :to => :organization

  enumerize :first_week_parity, :in => { :even => 0, :odd => 1 }

  normalize_attributes :ends_on, :parity, :starts_on, :title, :first_week_parity

  state_machine :status, :initial => :draft do
    event :publish do
      transition :draft => :published, :if => :can_publish?
    end

    event :unpublish do
      transition :published => :draft
    end

    after_transition do |timetable, transition|
      timetable.groups.reindex
      timetable.lecturers.reindex
    end
  end

  def can_publish?
    (organization.available_group_count - groups.count) > 0
  end

  def closest_week
    weeks.first
  end

  private

  def create_weeks
    number = 1
    week_parity = self.first_week_parity.value if parity?
    (self.starts_on.beginning_of_week.to_date..self.ends_on.end_of_week.to_date).each_slice(7) do |days|
      week_starts_on = days.first > starts_on ? days.first : starts_on
      if self.parity?
        parity = week_parity % 2 == 0 ? :even : :odd
        week = weeks.create(number: number, starts_on: week_starts_on, parity: parity)
        week_parity += 1
      else
        week = weeks.create(number: number, starts_on: week_starts_on)
      end
      number += 1
      days.each do |day|
        status = organization.holidays.map(&:date).include?(day) ? :holiday : nil
        week.days.create(date: day, status: status)
      end
    end
  end

  def initialize_lesson_times
    organization.lesson_times.each do |lesson_time|
      day, number, starts_at, ends_at = lesson_time.day, lesson_time.number, lesson_time.starts_at, lesson_time.ends_at
      lesson_times.build :day => day, :number => number, :starts_at => starts_at, :ends_at => ends_at
    end
  end
end
