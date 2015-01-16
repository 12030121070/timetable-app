module LessonsFor
  def lessons_for(group, discipline, week: nil, kind: nil)
    association = group.lessons.joins(:discipline).where('disciplines.id = ?', discipline.id)

    association = association.joins(:week).where('weeks.id = ?', week.id) if week
    association = association.where('lessons.kind = ?', kind) if kind

    association
  end
end
