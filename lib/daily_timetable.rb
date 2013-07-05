class DailyTimetable
  include ActiveAttr::MassAssignment

  attr_accessor :cells, :timetable, :day, :week

  delegate :groups, :to => :timetable

  def initialize(args)
    super(args)

    @cells = [[]]

    day.lesson_times.each do |lesson_time|
      row_cells = []
      (0..groups.size).each do |column|
        row_cells << TimetableCell.new(day, lesson_time)
      end
      @cells << row_cells
    end

    p day
    day.lessons.each do |lesson|
      lesson.groups.each do |group|
        p groups
        next unless groups.include?(group)
        @cells[lesson.lesson_time.number][groups.index(group) + 1].lesson = lesson
        p @cells[lesson.lesson_time.number][groups.index(group) + 1]
        p @cells[lesson.lesson_time.number][groups.index(group) + 1].lesson
      end
    end

    day.lesson_times.each do |lesson_time|
      @column_merging = false
      (1..groups.size).each do |column|
        @start_column = column unless @column_merging
        next if @cells[lesson_time.number][column].nil?

        if @cells[lesson_time.number][@start_column].eql?(@cells[lesson_time.number][column + 1])
          @column_merging = true
          @cells[lesson_time.number][@start_column].span_columns += 1
          @cells[lesson_time.number][column + 1].rendering = false
        else
          @column_merging = false
        end
      end
    end
  end
end
