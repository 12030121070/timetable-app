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

  def pdf
    pdf = Prawn::Document.new

    pdf.font_families.update 'Verdana' => { :normal => '/Library/Fonts/Verdana.ttf' }
    pdf.font 'Verdana', :size => 8

    raw_table = []

    row = [{ :content => '', :colspan => 2}]

    timetable.groups.each do |group|
      row << group.title
    end

    raw_table << row

    cells.each do |day, lesson_times|
      next if lesson_times.empty?

      row = [{:content => day.day_name, :rowspan => day.lesson_times.count}]
      row << "#{lesson_times.first.starts_at} - #{lesson_times.first.ends_at}"
      timetable.groups.each do |group|
        row << '-'
      end
      raw_table << row

      lesson_times[1..-1].each do |lesson_time|
        row = []
        row << "#{lesson_time.starts_at} - #{lesson_time.ends_at}"
        timetable.groups.each do |group|
          row << '-'
        end
        raw_table << row
      end
    end

    pdf.table(raw_table)

    pdf
  end
end
