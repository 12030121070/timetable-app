module FreeCells
  def free_cells_at(week)
    cells = week.cells
    lessons.where(:day_id => week.days).each do |lesson|
      cells[lesson.day] -= [lesson.lesson_time]
    end

    cells
  end
end
