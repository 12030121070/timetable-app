#encoding: utf-8

class Pdf::Cell
  include ActiveAttr::MassAssignment

  attr_accessor :content, :colspan, :rowspan, :visible,
    :day, :lesson_time, :group, :lessons

  def initialize(args = {})
    super(args)

    @content ||= ''
    @lessons ||= []
    @colspan ||= 1
    @rowspan ||= 1
    @visible ||= true
  end

  def to_h
    { :content => content, :colspan => colspan, :rowspan => rowspan }
  end

  def visible?
    visible
  end

  def content
    return lessons_content if lessons.any?

    @content
  end

  def ==(other_cell)
    return content == other_cell.content if lessons.empty? && other_cell.lessons.empty?
    return false unless lessons.count == other_cell.lessons.count

    lessons.each_with_index do |lesson, index|
      other_lesson = other_cell.lessons[index]

      return false unless lesson.discipline == other_lesson.discipline &&
        lesson.kind == other_lesson.kind &&
        lesson.classrooms == other_lesson.classrooms &&
        lesson.lecturers == other_lesson.lecturers
    end

    true
  end

  def can_have_more_lesson?
    return false if lessons.many?
    lessons.each { |lesson| return false if lesson.subgroup_whole? }

    true
  end

  def lesson_starts_at
    Time.zone.parse lesson_time.starts_at
  end

  def lesson_ends_at
    Time.zone.parse lesson_time.ends_at
  end

  private

  def max_string_width
    20 * colspan
  end

  def lesson_title_or_abbr(lesson)
    lesson.discipline.title.size > max_string_width ? lesson.discipline.abbr : lesson.discipline.title
  end

  def lesson_lecturers(lesson)
    ''.tap do |string|
      string << lesson.lecturers.first.to_s

      return string if string.size > max_string_width

      lesson.lecturers[1..-1].each do |lecturer|
        string << ' и др.' and break if (string + lecturer.to_s).size > max_string_width
        string << ", #{lecturer.to_s}"
      end
    end
  end

  def lessons_content
    @lessons_conent ||= ''.tap do |content|
      if lessons.many?
        content << lessons.map { |lesson| "#{lesson.subgroup_text}: #{lesson.discipline.abbr}\n#{lesson.classrooms.join(', ')}" }.join("\n\n")
      else
        lesson = lessons.first
        content << "#{lesson_title_or_abbr(lesson)}\n"
        content << "#{lesson.kind_text}\n"
        content << "#{lesson.classrooms.join(', ')}\n" if lesson.classrooms.any?
        content << "#{lesson_lecturers(lesson)}\n" if lesson.lecturers.any?
        content << lesson.subgroup_text unless lesson.subgroup_whole?
      end
    end
  end
end
