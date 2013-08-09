class Lecturer < ActiveRecord::Base
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
    "#{surname.mb_chars.capitalize} #{name.first.mb_chars.capitalize}.#{patronymic.first.mb_chars.capitalize}."
  end
  alias_method :to_s, :short_name

  def table(week_start_on)
    foo(week_start_on).each do |date, hash|
      hash.each do |_, another_hash|
        another_hash[:lessons] = another_hash[:lesson_times].flat_map { |lt| lessons.joins(:day).where('days.date = ?', date).where('lessons.lesson_time_id =?', lt.id) }
      end
    end
  end

  def foo(week_start_on)
    weeks = organization.weeks.includes(:days => { :week => { :timetable => :lesson_times } }).where(:starts_on => week_start_on)

    hash = {}

    weeks.flat_map(&:days).group_by(&:date).each do |date, days|
      hash[date] = {}

      days.each do |day|
        lesson_times = organization.lesson_times.where('lesson_times.day = ?', day.cwday)

        next if lesson_times.empty?

        curr_lt = lesson_times.first

        k = 1
        lesson_times.each do |lt|
          k += 1 and curr_lt = lt if curr_lt.starts_at != lt.starts_at && curr_lt.ends_at != lt.ends_at

          hash[date][k] ||= {}

          hash[date][k][:starts_at] = curr_lt.starts_at
          hash[date][k][:ends_at]   = curr_lt.ends_at

          hash[date][k][:lessons] = []
          hash[date][k][:lesson_times] ||= []
          hash[date][k][:lesson_times] << lt
          hash[date][k][:lesson_times].uniq!
        end
      end
    end

    hash
  end
end
