require "prawn/measurement_extensions"

module ::Prawn
  class Table
    def column_widths
      [36, 36] + (2..cells.length).map { 108 }
    end
  end
end

class Pdf::Week
  attr_accessor :week

  def initialize(week)
    @week = week
  end

  def render
    generate
    pdf.render
  end

  def timetable
    @timetable ||= @week.timetable
  end

  def groups
    @groups ||= timetable.groups
  end

  def cells
    @cells ||= @week.cells
  end

  def groups_per_page
    10
  end

  def set_colspans(table_data)
    table_data[:days].each do |_, rows|
      rows.each { |row| row = set_spans(row, :colspan) }
    end
  end

  def set_rowspans(table_data)
    group_size = table_data[:days].values.first.first.count - 2

    table_data[:days].each do |_, rows|
      new_rows = []
      rows.each { |row| new_rows << row[row.size - group_size..row.size] }

      new_rows = new_rows.transpose
      new_rows.each { |row| row = set_spans(row, :rowspan) }
      new_rows = new_rows.transpose

      rows.each_with_index { |row, index| row[row.size - group_size..row.size] = new_rows[index] }
    end
  end

  def pages
    @pages ||= [].tap do |array|
      groups.each_slice(groups_per_page) { |groups| array << table_data(groups) }
    end
  end

  def table_data(groups = timetable.groups)
    {}.tap do |table_data|
      table_data[:header] = [Pdf::Cell.new(:colspan => 2)]
      groups.each { |group| table_data[:header] << Pdf::Cell.new(:content => group.title) }

      table_data[:days] = {}

      cells.each do |day, lesson_times|
        next if lesson_times.empty?

        table_data[:days][day] = []

        # TODO: extract into method
        [lesson_times.first].each do |lesson_time|
          row = [Pdf::Cell.new(:day => day, :content => day.day_name, :rowspan => lesson_times.length)]
          row << Pdf::Cell.new(:lesson_time => lesson_time)

          groups.each_with_index do |group, index|
            lessons = group.lessons.joins(:day).where(:lessons => {:lesson_time_id => lesson_time.id}).where(:days => { :id => day.id })
            row << Pdf::Cell.new(:day => day, :lesson_time => lesson_time, :group => group, :lessons => lessons)
          end
          table_data[:days][day] << row
        end

        # TODO: extract into method
        lesson_times[1..-1].each do |lesson_time|
          row = [Pdf::Cell.new(:lesson_time => lesson_time)]

          groups.each_with_index do |group, index|
            lessons = group.lessons.joins(:day).where(:lessons => {:lesson_time_id => lesson_time.id}).where(:days => { :id => day.id })
            row << Pdf::Cell.new(:day => day, :lesson_time => lesson_time, :group => group, :lessons => lessons)
          end
          table_data[:days][day] << row
        end
      end
    end
  end

  private

  def set_spans(array, method)
    array.each_with_index do |e, i|
      next if array[i].content.blank?

      matches = 0
      (i + 1...array.length).each do |j|
        break unless array[i] == array[j]
        matches += 1
      end

      if matches > 0
        return if method == :rowspan && array[i].colspan > 1

        array[i].send "#{method}=", matches + 1
        (i + 1..i + matches).each { |k| array[k].visible = false }
      end
    end
  end

  def pdf
    @pdf ||= Prawn::Document.new(:page_size => 'A3', :page_layout => :landscape, :margin => [0.25.in, 0.25.in])
  end

  def set_font_style
    pdf.font_families.update 'Verdana' => { :normal => "#{Rails.root}/lib/assets/Verdana.ttf" }
    pdf.font 'Verdana', :size => 8
  end

  def generate
    set_font_style

    pages.each do |page|
      pdf.text timetable.title, :size => 16
      pdf.move_down 10

      set_colspans(page)
      set_rowspans(page)

      table = [ page[:header].select(&:visible?).map(&:to_h) ]

      page[:days].each do |day, array|
        array.each { |elem| table << elem.select(&:visible?).map(&:to_h) }
      end

      pdf.table(table) do
        cells.style :align => :center, :valign => :center, :height => 0.75.in
        row(0).height = 0.25.in
      end

      pdf.start_new_page unless pages.last == page
    end
  end
end
