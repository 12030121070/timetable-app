class Timetable < ActiveRecord::Base
  extend Enumerize

  attr_accessible :ends_on, :parity, :starts_on, :title, :first_week_parity,
    :lesson_times_attributes

  belongs_to :organization

  has_many :groups,       :dependent => :destroy, :order => 'groups.id ASC'
  has_many :lesson_times, :dependent => :destroy, :order => 'day ASC, number ASC', :as => :context
  has_many :weeks,        :dependent => :destroy, :order => 'starts_on ASC, number ASC'

  has_many :days,      :through => :weeks, :order => 'days.date ASC'
  has_many :lecturers, :through => :lessons, :uniq => true
  has_many :lessons,   :through => :lesson_times

  validates_presence_of :title, :starts_on, :ends_on
  validates_presence_of :first_week_parity, :if => :parity?

  accepts_nested_attributes_for :lesson_times, :allow_destroy => true

  before_validation :set_lesson_times_number
  after_initialize :initialize_lesson_times, :if => ->(timetable) { timetable.new_record? && timetable.lesson_times.empty? }
  after_save :create_weeks_and_days

  delegate :organization_holidays, :to => :organization

  enumerize :first_week_parity, :in => [:odd, :even]

  normalize_attributes :ends_on, :starts_on, :title

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
    week = weeks.current.first

    if week.nil?
      past_week = weeks.past.last
      future_week = weeks.future.first

      if past_week && future_week
        if (past_week.date_on.end_of_week..Time.zone.today).count < (Time.zone.today..future_week.date_on.beginning_of_week).count
          week = past_week
        else
          week = future_week
        end
      else
        week = past_week if past_week
        week = future_week if future_week
      end
    end

    week
  end

  private

  def initialize_lesson_times
    organization.lesson_times.each do |lesson_time|
      day, number, starts_at, ends_at = lesson_time.day, lesson_time.number, lesson_time.starts_at, lesson_time.ends_at
      lesson_times.build :day => day, :number => number, :starts_at => starts_at, :ends_at => ends_at
    end
  end

  def set_lesson_times_number
    lesson_times.group_by(&:day).each do |day, lts|
      lts.select{|lt| lt.starts_at.present?}.sort_by{|lt| Time.zone.parse(lt.starts_at)}.each_with_index do |lt, index|
        lt.number = index+1
      end
    end
  end

  def create_day_for(week)
    (week.starts_on..week.ends_on).each { |date| week.days.find_or_create_by_date(date) }
  end

  def refresh_weeks_and_days
    (starts_on.beginning_of_week..ends_on.end_of_week).each_slice(7) do |dates|
      week = weeks.find_or_create_by_starts_on(dates.first.beginning_of_week)
      create_day_for(week)
    end
  end

  def set_week_numbers
    weeks.reload.each_with_index { |week, index| week.update_attribute :number, index + 1 }
  end

  def set_week_parities
    parity_values = ([first_week_parity] | self.class.first_week_parity.values).cycle

    weeks.reload.each { |week, index| week.update_attribute :parity, parity_values.next }
  end

  def destroy_stale_days
    days.select { |day| !(starts_on..ends_on).include?(day.date) }.map(&:destroy)
  end

  def destroy_stale_weeks
    weeks.select { |week| week.days.empty? }.map(&:destroy)
  end

  def create_weeks_and_days
    destroy_stale_days
    destroy_stale_weeks
    refresh_weeks_and_days
    set_week_numbers
    set_week_parities if parity?
  end
end
