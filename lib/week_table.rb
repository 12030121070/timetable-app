class WeekTable
  def initialize(week)
    @week ||= week
  end

  def pages
    [].tap do |arr|
      timetable.groups.each_slice(groups_per_page) do |groups|
        arr << table_for_days(groups)
      end
    end
  end

  def table_for_days(groups)
    @week.days.includes(:lessons).map { |d| table_for_day(d, groups) }
  end

  def table_for_day(day, groups)
    [].tap do |arr|
      timetable.lesson_times.for_day(day.cwday).each_with_index do |lt, index|
        groups.each do |group|
          arr[index] ||= []
          arr[index] << group.lessons.joins(:day).where(:lessons => {:lesson_time_id => lt.id}).where(:days => { :id => day.id })
        end
      end
    end
  end

  def groups_per_page
    3
  end

  def lessons_time_per_page
    14
  end

  def timetable
    @timetable ||= @week.timetable
  end
end
