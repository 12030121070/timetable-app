class TimetableStatistics
  extend ActiveSupport::Memoizable

  attr_accessor :timetable

  def initialize(timetable)
    @timetable = timetable
  end

  def weeks
    @weeks ||= timetable.weeks
  end

  def data
    hash = {}

    timetable.groups.each do |g|
      hash[g] = {}

      g.disciplines.each do |d|
        hash[g][d] = {}

        lessons_for(g, d).pluck('lessons.kind').each do |k|
          hash[g][d][kinds(k)] = {}

          weeks.each do |w|
            hash[g][d][kinds(k)][w] = lessons_for(g, d, w).count
          end
        end
      end
    end

    hash
  end

  def lessons_for(group, discipline, week = nil)
    association = group.lessons.joins(:discipline).where('disciplines.id = ?', discipline.id)

    association = association.joins(:week).where('weeks.id = ?', week.id) if week

    association
  end

  def kinds(kind)
    Hash[Lesson.kind.options].invert[kind]
  end

  memoize :lessons_for, :kinds
end
