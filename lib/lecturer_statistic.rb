class LecturerStatistic
  attr_accessor :data, :lecturer, :timetable_ids

  def initialize(lecturer, timetable_ids)
    @lecturer = lecturer
    @timetable_ids = timetable_ids
    @data = {}
    fill_data
    self
  end

  def lessons
    if timetable_ids
      @lessons ||= lecturer.lessons.joins(:timetable).where(:timetables => { :id => timetable_ids })
    else
      @lessons ||= lecturer.lessons.joins(:timetable)
    end
  end

  def weeks
    @weeks ||= lessons.flat_map(&:week).map(&:number).uniq
  end

  def groups
    @groups ||= lessons.flat_map(&:groups).uniq
  end

  private

  def fill_data
    lessons.each do |lesson|
      lesson.groups.each do |group|
        data[group.title] ||= {}
        data[group.title][lesson.discipline.title] ||= {}
        data[group.title][lesson.discipline.title][kinds(lesson.kind)] ||= {}
        data[group.title][lesson.discipline.title][kinds(lesson.kind)][lesson.week.number] ||= 0
        data[group.title][lesson.discipline.title][kinds(lesson.kind)][lesson.week.number] += 1
      end
    end
    @data = data.sort.to_h
  end

  def kinds(kind)
    Hash[Lesson.kind.options].invert[kind]
  end
end
