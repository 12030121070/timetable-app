class LessonTime < ActiveRecord::Base
  attr_accessible :day, :ends_at, :number, :starts_at

  belongs_to :context, :polymorphic => true

  validates_presence_of :day, :number, :starts_at, :ends_at
  validates_uniqueness_of :number, :scope => [:day, :context_type, :context_id]
  validate :format_of_time

  scope :for_day, -> (day) { where :day => day }
  scope :for_number, -> (number) { where :number => number }

  def last_in_day?
    context.lesson_times.for_day(day).maximum(:number) == number
  end

  def format_of_time
    errors.add(:starts_at, 'Wrong format') unless self.starts_at.match(/\A\d{,2}:\d{2}\Z/)
    errors.add(:ends_at, 'Wrong format') unless self.ends_at.match(/\A\d{,2}:\d{2}\Z/)
  end
end
