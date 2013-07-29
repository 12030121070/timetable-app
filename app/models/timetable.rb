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

  enumerize :first_week_parity, :in => { :odd => 1, :even => 0 }

  normalize_attributes :ends_on, :parity, :starts_on, :title, :first_week_parity

  state_machine :status, :initial => :draft do
    event :publish do
      transition :draft => :published, :if => :can_publish?
    end

    event :unpublish do
      transition :published => :draft
    end
  end

  def can_publish?
    (organization.available_group_count - groups.count) > 0
  end

  private

  def create_weeks
    number = 1
    week_parity = self.first_week_parity.value
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
        status = organization.holidays.include?(day) ? :holiday : nil
        week.days.create(date: day, status: status)
      end
    end
  end

  def create_lesson_times
    (1..6).each do |day|
      lesson_times.create :day => day, :number => 1, :starts_at =>  '8:50', :ends_at => '10:25'
      lesson_times.create :day => day, :number => 2, :starts_at => '10:40', :ends_at => '12:15'
      lesson_times.create :day => day, :number => 3, :starts_at => '13:15', :ends_at => '14:50'
      lesson_times.create :day => day, :number => 4, :starts_at => '15:00', :ends_at => '16:35'
      lesson_times.create :day => day, :number => 5, :starts_at => '16:45', :ends_at => '18:20'
      lesson_times.create :day => day, :number => 6, :starts_at => '18:30', :ends_at => '20:05'
      lesson_times.create :day => day, :number => 7, :starts_at => '20:15', :ends_at => '21:50'
    end
  end
end
