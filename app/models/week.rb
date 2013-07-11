# encoding: utf-8

class Week < ActiveRecord::Base
  attr_accessible :number, :starts_on, :parity

  belongs_to :timetable

  has_many :days, :order => 'days.date ASC'

  extend Enumerize
  enumerize :parity, in: [:odd, :even], predicates: true

  scope :even, -> { where(parity: :even) }
  scope :odd, -> { where(parity: :odd) }

  def to_s
    "неделя #{number}, #{starts_on}"
  end

  def copy_to(recipients)
    recipients.each do |recipient|
      self.days.each do |day|
        recipient_day = recipient.days.select{|d| d.date.cwday == day.date.cwday }.first
        day.lessons.each do |lesson|
          lesson.copy_to(recipient_day)
        end
      end
    end
  end

  def cells
    @cells ||= {}.tap do |hash|
      days.each { |day| hash[day] = day.lesson_times }
    end
  end

  # TODO: optimize
  def pdf
    pdf = Prawn::Document.new(:page_size => 'A3', :page_layout => :landscape)

    pdf.font_families.update 'Verdana' => { :normal => "#{Rails.root}/lib/assets/Verdana.ttf" }
    pdf.font 'Verdana', :size => 8

    raw_table = []
    row = [{ :content => '', :colspan => 2}]
    timetable.groups.each { |group| row << group.title }
    raw_table << row

    cells.each do |day, lesson_times|
      next if lesson_times.empty?

      row = [{:content => day.day_name, :rowspan => day.lesson_times.count}]
      row << "#{lesson_times.first.starts_at} - #{lesson_times.first.ends_at}"
      timetable.groups.each_with_index do |group, index|
        cell = DailyTimetable.new(:timetable => timetable, :day => day ,:week => self).cells[lesson_times.first.number][index + 1]

        content = ''.tap do |content|
          cell.lessons.each do |lesson|
            content << "#{lesson.discipline.abbr}\n"
            content << "#{lesson.kind_text}\n"
            content << "#{lesson.classrooms.map(&:to_s).join(', ')}\n" if lesson.classrooms.any?
            content << "#{lesson.lecturers.map(&:to_s).join(', ')}\n" if lesson.lecturers.any?
          end
        end

        row << {
          :content => content,
          :rowspan => cell.span_rows,
          :colspan => cell.span_columns
        } if cell.rendering?
      end
      raw_table << row

      lesson_times[1..-1].each do |lesson_time|
        row = []
        row << "#{lesson_time.starts_at} - #{lesson_time.ends_at}"
        timetable.groups.each_with_index do |group, index|
          cell = DailyTimetable.new(:timetable => timetable, :day => day ,:week => self).cells[lesson_time.number][index + 1]

          content = ''.tap do |content|
            cell.lessons.each do |lesson|
              content << "#{lesson.discipline.abbr}\n"
              content << "#{lesson.kind_text}\n"
              content << "#{lesson.classrooms.map(&:to_s).join(', ')}\n" if lesson.classrooms.any?
              content << "#{lesson.lecturers.map(&:to_s).join(', ')}\n" if lesson.lecturers.any?
            end
          end

          row << {
            :content => content,
            :rowspan => cell.span_rows,
            :colspan => cell.span_columns
          } if cell.rendering?
        end
        raw_table << row
      end
    end

    pdf.table(raw_table) do
      column(0).width = 50
      column(1).width = 70
      cells.style :valign => :center, :align => :center
    end

    pdf
  end
end
