#encoding: utf-8

require "prawn/measurement_extensions"

module ::Prawn
  class Table
    def column_widths
      [36, 72] + (2..cells.length).map { 108 }
    end
  end
end

class PdfWeek
  attr_accessor :week

  delegate :timetable, :cells, :to => :week
  delegate :render, :to => :pdf

  def initialize(week)
    @week = week

    generate
  end

  private

  def pdf
    @pdf ||= Prawn::Document.new(:page_size => 'A3', :page_layout => :landscape, :margin => [0.25.in, 0.5.in])
  end

  def set_font_style
    pdf.font_families.update 'Verdana' => { :normal => "#{Rails.root}/lib/assets/Verdana.ttf" }
    pdf.font 'Verdana', :size => 8
  end

  def max_groups_on_page
    9
  end

  def colspan(cell, index)
    return cell.span_columns if cell.span_columns == 1

    cell.span_columns > max_groups_on_page - index ? max_groups_on_page - index : cell.span_columns
  end

  def rendering(cell, index)
    return true if index.zero?

    return cell.rendering?
  end

  def generate
    set_font_style

    external_index = 0
    timetable.groups.each_slice(9) do |groups|
      pdf.text 'Расписание', :size => 16
      pdf.move_down 10

      raw_table = []
      row = [{ :content => '', :colspan => 2}]
      groups.each { |group| row << group.title }
      raw_table << row

      cells.each do |day, lesson_times|
        next if lesson_times.empty?

        row = [{:content => day.day_name, :rowspan => day.lesson_times.count}]
        row << "#{lesson_times.first.starts_at} - #{lesson_times.first.ends_at}"
        groups.each_with_index do |group, index|
          cell = DailyTimetable.new(:timetable => timetable, :day => day ,:week => week).cells[lesson_times.first.number][external_index + index + 1]

          content = ''.tap do |content|
            cell.lessons.each do |lesson|
              content << "#{lesson.discipline.title}\n"
              content << "#{lesson.kind_text}\n"
              content << "#{lesson.classrooms.map(&:to_s).join(', ')}\n" if lesson.classrooms.any?
              content << "#{lesson.lecturers.map(&:to_s).join(', ')}\n" if lesson.lecturers.any?
            end
          end

          row << {
            :content => content,
            :rowspan => cell.span_rows,
            :colspan => colspan(cell, index)
          } if rendering(cell, index)
        end
        raw_table << row

        lesson_times[1..-1].each do |lesson_time|
          row = []
          row << "#{lesson_time.starts_at} - #{lesson_time.ends_at}"
          groups.each_with_index do |group, index|
            cell = DailyTimetable.new(:timetable => timetable, :day => day ,:week => week).cells[lesson_time.number][external_index + index + 1]

            content = ''.tap do |content|
              cell.lessons.each do |lesson|
                content << "#{lesson.discipline.title}\n"
                content << "#{lesson.kind_text}\n"
                content << "#{lesson.classrooms.map(&:to_s).join(', ')}\n" if lesson.classrooms.any?
                content << "#{lesson.lecturers.map(&:to_s).join(', ')}\n" if lesson.lecturers.any?
              end
            end

            row << {
              :content => content,
              :rowspan => cell.span_rows,
              :colspan => colspan(cell, index)
            } if rendering(cell, index)
          end
          raw_table << row
        end
      end

      pdf.table(raw_table) do
        cells.style :align => :center, :valign => :center, :height => 0.75.in

        row(0).height = 0.25.in
        columns(0).width = 0.25.in
        columns(1).width = 1.in
      end

      external_index += 9
      pdf.start_new_page
    end

    pdf
  end
end
