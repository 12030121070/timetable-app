# TODO: шитокод ;(
module WeekTimetable
  def beginning_of_weeks
    organization.published_weeks.pluck(:starts_on).uniq.sort
  end

  def table(week_start_on)
    @table ||= {}.tap do |hash|
      weeks = organization.published_weeks.includes(:days => { :week => { :timetable => :lesson_times } }).where(:starts_on => week_start_on)

      weeks.flat_map(&:days).group_by(&:date).each do |date, days|
        hash[date] = {}

        days.each do |day|
          lesson_times = organization.timetable_lesson_times.where('lesson_times.day = ?', day.cwday)

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

      hash.each do |date, data|
        data.each do |_, value|
          value[:lessons] = value[:lesson_times].flat_map { |lt| lessons.joins(:day).where('days.date = ?', date).where('lessons.lesson_time_id =?', lt.id) }
        end
      end
    end
  end
end
