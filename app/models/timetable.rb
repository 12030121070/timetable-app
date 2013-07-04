class Timetable < ActiveRecord::Base
  attr_accessible :ends_on, :parity, :starts_on, :status, :title

  after_create :create_weeks

  belongs_to :organization

  extend Enumerize
  enumerize :status, in: [:draft, :published], predicates: true

  has_many :weeks, dependent: :destroy

  validates_presence_of :title, :starts_on, :ends_on

  private

  def create_weeks
    number = 1
    (self.starts_on.beginning_of_week..self.ends_on).each_slice(7) do |days|
      week = weeks.create(:number => number, :starts_on => days.first > starts_on ? days.first : starts_on)
      days.each do |day|
        week.days.create()
      end
    end
  end
end
