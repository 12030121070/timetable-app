class Timetable < ActiveRecord::Base
  extend Enumerize

  attr_accessible :ends_on, :parity, :starts_on, :title, :first_week_parity

  belongs_to :organization

  has_many :groups, :dependent => :destroy, :order => 'groups.title ASC'
  has_many :lesson_times, :as => :context, :dependent => :destroy, :order => 'day ASC, number ASC'
  has_many :weeks, dependent: :destroy, :order => 'number ASC'

  validates_presence_of :title, :starts_on, :ends_on

  after_create :create_weeks
  after_create :create_lesson_times

  delegate :organization_holidays, :to => :organization

  enumerize :status,
    in: [:draft, :published],
    predicates: true,
    default: :draft

  normalize_attributes :ends_on, :parity, :starts_on, :title, :first_week_parity

  %w[draft published].each do |status|
    define_method("to_#{status}") { update_attribute :status, status }
  end

  private

  def create_weeks
    number = 1
    week_parity = self.first_week_parity
    (self.starts_on.beginning_of_week.to_date..self.ends_on.to_date).each_slice(7) do |days|
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
        status = organization_holidays.pluck(:date).include?(day) ? :holiday : nil
        week.days.create(date: day, status: status)
      end
    end
  end

  def create_lesson_times
    (1..6).each do |day|
      (1..6).each do |number|
        lesson_times.create :day => day, :number => number, :starts_at => '0:00', :ends_at => '0:00'
      end
    end
  end
end
