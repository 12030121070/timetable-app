class TimetableCell
  attr_accessor :lesson, :span_columns, :span_rows, :rendering, :day, :number, :lesson_time

  delegate :name, :abbr, :nil?, :to => :lesson, :prefix => true

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

  def kind
    lesson ? lesson.kind : ""
  end

  def eql?(cell)
    return false unless cell
    return false if cell.lesson.nil? || lesson.nil?

    cell.lesson.eql?(lesson)
  end
end
