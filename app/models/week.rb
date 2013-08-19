# encoding: utf-8

class Week < ActiveRecord::Base
  attr_accessible :number, :starts_on, :parity

  belongs_to :timetable

  has_many :days, :order => 'days.date ASC'
  has_many :lessons, :through => :days
  has_many :study_days, :through => :lessons, :source => :day, :uniq => true, :order => 'days.date ASC'

  extend Enumerize
  enumerize :parity, in: [:odd, :even], predicates: true

  scope :even, -> { where(parity: :even) }
  scope :odd, -> { where(parity: :odd) }
  scope :current, -> { where('weeks.starts_on BETWEEN ? AND ?', Time.zone.today.beginning_of_week, Time.zone.today.end_of_week) }
  scope :future, -> { where('weeks.starts_on > ?', Time.zone.today.beginning_of_week).order('weeks.starts_on ASC') }
  scope :past, -> { where('weeks.starts_on < ?', Time.zone.today.beginning_of_week).order('weeks.starts_on ASC') }

  def to_s
    "неделя #{number}, #{starts_on}"
  end

  def copy_to(recipients)
    recipients.each do |recipient|
      self.days.each do |day|
        recipient_day = recipient.days.select{|d| d.date.cwday == day.date.cwday }.first
        day.lessons.each do |lesson|
          lesson.copy_to(recipient_day)
        end
      end
    end
  end

  def cells
    @cells ||= {}.tap do |hash|
      days.each { |day| hash[day] = day.lesson_times }
    end
  end

  def next
    return nil if self_index+1 == timetable_weeks.count
    timetable_weeks[self_index+1]
  end

  def prev
    return nil if self_index.zero?
    timetable_weeks[self_index-1]
  end

  def timetable_weeks
    @timetable_weeks ||= timetable.weeks
  end

  def self_index
    @self_index ||= timetable_weeks.index(self)
  end
end
