class Lecturer < ActiveRecord::Base
  attr_accessible :name, :patronymic, :surname

  validates_presence_of :name, :patronymic, :surname

  belongs_to :organization

  has_many :lecturer_lessons
  has_many :lessons, :through => :lecturer_lessons

  normalize_attributes :name, :patronymic, :surname

  def full_name
    "#{surname} #{name} #{patronymic}"
  end
  alias_method :to_s, :full_name

  def free_cells_at(week)
    cells = week.cells
    lessons.where(:day_id => week.days).each do |lesson|
      cells[lesson.day] -= [lesson.lesson_time]
    end

    cells
  end
end
