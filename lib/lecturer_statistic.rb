class LecturerStatistic
  include LessonsFor
  attr_accessor :data, :lecturer, :timetable_ids

  def initialize(lecturer, timetable_ids)
    @lecturer = lecturer
    @timetable_ids = timetable_ids
    @data = {}
    fill_data
    self
  end

  def timetables
    @timetables ||= lecturer.timetables.where(:id => timetable_ids.to_a.compact.map(&:to_i))
  end

  def weeks
    @weeks ||= timetables.flat_map(&:weeks).map(&:number).uniq
  end

  private

  def fill_data
    timetables.flat_map(&:groups).sort_by(&:title).each do |group|
      data[group] = {}
      group.disciplines.each do |discipline|
        data[group][discipline.title] = {}
        lessons_for(group, discipline).map(&:kind).each do |k|
          data[group][discipline.title][kinds(k)] = {}
          weeks.each do |w|
            data[group][discipline.title][kinds(k)][w] = lessons_for(group, discipline, week: group.timetable.weeks.find_by_number(w), kind: k).count
          end
        end
      end
    end
  end

  def kinds(kind)
    Hash[Lesson.kind.options].invert[kind]
  end
end
