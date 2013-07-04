class LessonTime < ActiveRecord::Base
  attr_accessible :day, :ends_at, :number, :starts_at

  belongs_to :context, :polymorphic => true

  validates_presence_of :day, :number, :starts_at, :ends_at

  scope :for_day, -> (day) { where :day => day }
end
