require "prawn/measurement_extensions"

module ::Prawn
  class Table
    def column_widths
      [36, 72] + (2..cells.length).map { 108 }
    end
  end
end

class Pdf::Week
  attr_accessor :week

  delegate :timetable, :cells, :to => :week
  delegate :cells, :to => :week, :prefix => true

  def initialize(week)
    @week = week
  end

  def table_data
    @table_data ||= {}.tap do |table_data|
      table_data[:header] = [Pdf::Cell.new('', 2, 1)]
      timetable.groups.each { |group| table_data[:header] << Pdf::Cell.new(group.title) }

      table_data[:days] = {}

      week_cells.each do |day, lesson_times|
        next if lesson_times.empty?

        table_data[:days][day] = []

        # TODO: extract into method
        lesson_time = lesson_times.first
        row = [Pdf::Cell.new(day.day_name, 1, lesson_times.length)]
        row << Pdf::Cell.new("#{lesson_time.starts_at} - #{lesson_time.ends_at}")

        timetable.groups.each_with_index do |group, index|
          cell = DailyTimetable.new(:timetable => timetable, :day => day ,:week => week).cells[lesson_time.number][index + 1]

          content = ''.tap do |content|
            cell.lessons.each do |lesson|
              content << "#{lesson.discipline.title}\n"
              content << "#{lesson.kind_text}\n"
              content << "#{lesson.classrooms.map(&:to_s).join(', ')}\n" if lesson.classrooms.any?
              content << "#{lesson.lecturers.map(&:to_s).join(', ')}\n" if lesson.lecturers.any?
            end
          end

          row << Pdf::Cell.new(content)
        end
        table_data[:days][day] << row

        # TODO: extract into method
        lesson_times[1..-1].each do |lesson_time|
          row = [Pdf::Cell.new("#{lesson_time.starts_at} - #{lesson_time.ends_at}")]

          timetable.groups.each_with_index do |group, index|
            cell = DailyTimetable.new(:timetable => timetable, :day => day ,:week => week).cells[lesson_time.number][index + 1]

            content = ''.tap do |content|
              cell.lessons.each do |lesson|
                content << "#{lesson.discipline.title}\n"
                content << "#{lesson.kind_text}\n"
                content << "#{lesson.classrooms.map(&:to_s).join(', ')}\n" if lesson.classrooms.any?
                content << "#{lesson.lecturers.map(&:to_s).join(', ')}\n" if lesson.lecturers.any?
              end
            end

            row << Pdf::Cell.new(content)
          end
          table_data[:days][day] << row
        end
      end
    end
  end

  def set_spans(array, method)
    array.each_with_index do |e, i|
      next if array[i].content.blank?

      matches = 0
      (i + 1...array.length).each do |j|
        break if array[i].content != array[j].content

        matches += 1
      end

      if matches > 0
        array[i].send "#{method.to_s}=", matches + 1
        (i + 1..i + matches).each { |k| array[k].visibiliity = false }
      end
    end
  end

  def set_colspans
    table_data[:days].each do |_, rows|
      rows.each do |row|
        row = set_spans(row, :colspan)
      end
    end
  end

  def set_rowspans
    table_data[:days].each do |_, rows|
      new_rows = []

      rows.each do |row|
        new_rows << row[row.size - timetable.groups.size..row.size]
      end

      new_rows = new_rows.transpose
      new_rows.each { |row| row = set_spans(row, :rowspan) }
      new_rows = new_rows.transpose

      rows.each_with_index do |row, index|
        row[row.size - timetable.groups.size..row.size] = new_rows[index]
      end
    end
  end

  def generate_pdf
    set_colspans
    set_rowspans

    pdf = Prawn::Document.new(:page_size => 'A3', :page_layout => :landscape, :margin => [0.25.in, 0.5.in])
    pdf.font_families.update 'Verdana' => { :normal => "#{Rails.root}/lib/assets/Verdana.ttf" }
    pdf.font 'Verdana', :size => 8

    rows = []
    rows << table_data[:header].select(&:visibiliity?).map(&:to_h)

    table_data[:days].each do |day, array|
      array.each do |elem|
        rows << elem.select(&:visibiliity?).map(&:to_h)
      end
    end

    pdf.table(rows) do
      cells.style :align => :center, :valign => :center, :height => 0.75.in

      row(0).height = 0.25.in
    end

    pdf.render
  end
end
