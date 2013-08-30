module TableForWeek
  extend ActiveSupport::Concern

  included do
    if self == Group
      def timetables
        Timetable.where :id => timetable.id
      end
    end
  end

  def table_for(week_starts_on)
    table = {}

    if week = weeks.find_by_starts_on(week_starts_on)
      table[:days] = week.days

      table[:lessons] = {}

      uniq_lesson_time_borders.each do |k, v|
        table[:lessons][k] = {}
        starts_at, ends_at = k.split('-')
        week.days.each do |day|
          table[:lessons][k][day.date.to_s] = lessons
           .joins(:day).where('days.date = ?', day.date)
           .joins(:lesson_time).where('lesson_times.starts_at = ? AND lesson_times.ends_at = ?', starts_at, ends_at)
        end
      end
    end

    table
  end

  private

  def uniq_lesson_time_borders
    uniq_lesson_time_borders = {}.tap do |hash|
      timetables.includes(:weeks => [:days]).includes(:lesson_times).each do |timetable|
        timetable.days.each do |day|
          timetable.lesson_times.where(:day => day.cwday).each do |lesson_time|
            hash["#{lesson_time.starts_at}-#{lesson_time.ends_at}"] = { :starts_at => Time.zone.parse(lesson_time.starts_at), :ends_at => Time.zone.parse(lesson_time.ends_at) }
          end
        end
      end
    end

    Hash[uniq_lesson_time_borders.sort_by { |_, v| v[:starts_at] }]
  end
end
