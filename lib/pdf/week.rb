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

  #def table_data
    ## TODO: lazy initialization
    #return @table_data if @table_data

    #rows = []

    #row = [Pdf::Cell.new('', 2, 1)]
    #timetable.groups.each { |group| row << Pdf::Cell.new(group.title) }
    #rows << row

    #week_cells.each do |day, lesson_times|
      #next if lesson_times.empty?

      ## TODO: extract into method
      #lesson_time = lesson_times.first
      #row = [Pdf::Cell.new(day.day_name, 1, lesson_times.length)]
      #row << Pdf::Cell.new("#{lesson_time.starts_at} - #{lesson_time.ends_at}")

      #timetable.groups.each_with_index do |group, index|
        #cell = DailyTimetable.new(:timetable => timetable, :day => day ,:week => week).cells[lesson_time.number][index + 1]

        #content = ''.tap do |content|
          #cell.lessons.each do |lesson|
            #content << "#{lesson.discipline.title}\n"
            #content << "#{lesson.kind_text}\n"
            #content << "#{lesson.classrooms.map(&:to_s).join(', ')}\n" if lesson.classrooms.any?
            #content << "#{lesson.lecturers.map(&:to_s).join(', ')}\n" if lesson.lecturers.any?
          #end
        #end

        #row << Pdf::Cell.new(content)
      #end
      #rows << row

      ## TODO: extract into method
      #lesson_times[1..-1].each do |lesson_time|
        #row = [Pdf::Cell.new("#{lesson_time.starts_at} - #{lesson_time.ends_at}")]

        #timetable.groups.each_with_index do |group, index|
          #cell = DailyTimetable.new(:timetable => timetable, :day => day ,:week => week).cells[lesson_time.number][index + 1]

          #content = ''.tap do |content|
            #cell.lessons.each do |lesson|
              #content << "#{lesson.discipline.title}\n"
              #content << "#{lesson.kind_text}\n"
              #content << "#{lesson.classrooms.map(&:to_s).join(', ')}\n" if lesson.classrooms.any?
              #content << "#{lesson.lecturers.map(&:to_s).join(', ')}\n" if lesson.lecturers.any?
            #end
          #end

          #row << Pdf::Cell.new(content)
        #end
        #rows << row
      #end
    #end

    #@table_data = rows
  #end

  def set_span(array, method)
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
    table_data.each do |row|
      row[2...2 + timetable.groups.count] = set_span(row[2...2 + timetable.groups.count], :colspan)
    end
  end

  def set_rowspans
    rows = []
    table_data[1..-1].each_with_index do |row, index|
      rows << row[row.size - timetable.groups.size..row.size]
    end

    rows = rows.transpose
    rows.each { |row| row = set_span(row, :rowspan) }
    rows = rows.transpose

    table_data.each_with_index do |row, index|
      row[2...2 + timetable.groups.count] = rows[index]
    end
  end

  def generate_pdf
    set_colspans
    set_rowspans

    pdf = Prawn::Document.new(:page_size => 'A3', :page_layout => :landscape, :margin => [0.25.in, 0.5.in])
    pdf.font_families.update 'Verdana' => { :normal => "#{Rails.root}/lib/assets/Verdana.ttf" }
    pdf.font 'Verdana', :size => 8

    rows = []
    table_data.each do |row|
      rows << row.select(&:visibiliity?).map(&:to_h)
    end

    pdf.table(rows) do
      cells.style :align => :center, :valign => :center, :height => 0.75.in

      row(0).height = 0.25.in
    end

    pdf.render
  end
end
