class DailyTimetable
  include ActiveAttr::MassAssignment

  attr_accessor :cells, :timetable, :day, :week

  delegate :groups, :to => :timetable

  def initialize(args)
    super(args)

    initialize_cells
    fill_cells
    merge_cells
  end

  private

  def initialize_cells
    @cells ||= [[]].tap do |cells|
      day.lesson_times.each do |lesson_time|
        row_cells = []
        (0..groups.size).each { |column| row_cells << TimetableCell.new(day, lesson_time) }
        cells << row_cells
      end
    end
  end

  def fill_cells
    day.lessons.each do |lesson|
      lesson.groups.each do |group|
        next unless groups.include?(group)
        cells[lesson.lesson_time.number][groups.index(group) + 1].lessons << lesson
      end
    end
  end

  def merge_cells
    day.lesson_times.each do |lesson_time|
      @column_merging = false

      (1..groups.size).each do |column|
        next if cells[lesson_time.number][column].nil?

        @start_column = column unless @column_merging

        if cells[lesson_time.number][@start_column].eql?(@cells[lesson_time.number][column + 1])
          @column_merging = true
          @cells[lesson_time.number][@start_column].span_columns += 1
          cells[lesson_time.number][column + 1].rendering = false
        else
          @column_merging = false
        end
      end
    end
  end
end
