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

        lessons_for(g, d).map(&:kind).each do |k|
          hash[g][d][kinds(k)] = {}

          weeks.each do |w|
            hash[g][d][kinds(k)][w] = lessons_for(g, d, week: w, kind: k).count
          end
        end
      end
    end

    hash
  end

  def lessons_for(group, discipline, week: nil, kind: nil)
    association = group.lessons.joins(:discipline).where('disciplines.id = ?', discipline.id)

    association = association.joins(:week).where('weeks.id = ?', week.id) if week
    association = association.where('lessons.kind = ?', kind) if kind

    association
  end

  def kinds(kind)
    Hash[Lesson.kind.options].invert[kind]
  end

  memoize :lessons_for, :kinds
end
