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
    @pdf ||= Prawn::Document.new(:page_size => 'A3', :page_layout => :landscape, :margin => [0.25.in, 0.25.in])
  end

  def set_font_style
    pdf.font_families.update 'Verdana' => { :normal => "#{Rails.root}/lib/assets/Verdana.ttf" }
    pdf.font 'Verdana', :size => 8
  end

  def generate
    set_font_style

    pages = WeekTable.new(week).pages
    pages.each do |page|
      table = [page.shift.map(&:title).unshift({ :content => '', :colspan => 2 })]
      page.each do |day|
        day_name = day.shift
        day.each_with_index do |time, index|
          row = time.each_with_index.map { |lt, i| decorate_cell(lt, day[index], i) }.delete_if{|i| !i.nil? && i.blank? }
          row.unshift({ :content => day_name.first.day_name, :rowspan => day.count }) if index == 0
          table << row
        end
      end

      pdf.table(table) do
        cells.style :align => :center, :valign => :center
      end
      pdf.start_new_page unless pages.last == page
    end
  end

  def decorate_cell(cell_item, row, i)
    if cell_item.one?
      return cell_item.first.to_s if cell_item.first.is_a?(LessonTime)

      if i-1 >= 0 && get_col_span(row[i-1], row, i-1) <= 1
        { :content => cell_item.first.to_s, :colspan => get_col_span(cell_item, row, i)}
      else
        ''
      end

    elsif cell_item.any?
      'Подrруппы'
    end
  end

  def get_col_span(cell_item, row, i)
    col_span = 0
    matched = false
    row.each_with_index do |item, index|
      if index >= i
        return col_span if matched && cell_item.first != item.first
        if cell_item.first == item.first
          matched = true
          col_span += 1
        end
      end
    end
    col_span
  end
end
