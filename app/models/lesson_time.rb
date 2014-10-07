# encoding: utf-8

class LessonTime < ActiveRecord::Base
  attr_accessible :day, :ends_at, :starts_at, :number

  belongs_to :context, :polymorphic => true

  has_many :lessons, :dependent => :destroy

  validates_presence_of :day, :starts_at, :ends_at
  validates_uniqueness_of :starts_at, :scope => [:ends_at, :day, :context_type, :context_id]
  validate :format_of_time

  scope :for_day, -> (day) { where :day => day }
  scope :for_number, -> (number) { where :number => number }

  def last_in_day?
    context.lesson_times.for_day(day).maximum(:number) == number
  end

  def format_of_time
    errors.add(:starts_at, 'Неверный формат') unless self.starts_at.match(/\A\d{,2}:\d{2}\Z/)
    errors.add(:ends_at, 'Неверный формат') unless self.ends_at.match(/\A\d{,2}:\d{2}\Z/)
  end

  def to_s
    "#{starts_at}–#{ends_at}"
  end
end
