class Lecturer < ActiveRecord::Base
  include WeekTimetable

  attr_accessible :name, :patronymic, :surname

  belongs_to :organization

  has_many :lecturer_lessons, :dependent => :destroy
  has_many :lessons, :through => :lecturer_lessons
  has_many :timetables, :through => :lessons, :uniq => true

  validates_presence_of :name, :patronymic, :surname

  scope :published, ->(i) { joins(:timetables).where("timetables.status = 'published'") }

  normalize_attributes :name, :patronymic, :surname

  searchable do
    text :full_name
    string :full_name
    integer :organization_id
    integer :published_lessons_count
  end

  def published_lessons_count
    lessons.published.count
  end

  def full_name
    "#{surname} #{name} #{patronymic}"
  end

  def short_name
    "#{surname.mb_chars.capitalize}&nbsp;#{name.first.mb_chars.capitalize}.#{patronymic.first.mb_chars.capitalize}.".html_safe
  end
  alias_method :to_s, :short_name
end
