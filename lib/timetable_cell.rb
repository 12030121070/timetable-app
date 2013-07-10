class TimetableCell
  attr_accessor :lessons, :span_columns, :span_rows, :rendering, :day, :number, :lesson_time

  delegate :empty?, :to => :lessons, :prefix => true


  def initialize(day, lesson_time)
    @span_columns = 1
    @span_rows    = 1
    @rendering    = true
    @day          = day
    @lesson_time  = lesson_time
    @number       = lesson_time.number
  end

  def rendering?
    @rendering
  end

  def eql?(cell)
    return false unless cell
    return false if cell.lessons.empty? || lessons.empty?

    lessons == cell.lessons
  end

  def lessons
    @lessons ||= []
  end

  def can_have_more_lesson?
    return false if lessons.many?
    lessons.each { |lesson| return false if lesson.subgroup_whole? }

    true
  end
end
