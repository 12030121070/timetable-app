# encoding: utf-8

class Week < ActiveRecord::Base
  attr_accessible :number, :starts_on, :parity

  belongs_to :timetable

  has_many :days

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
end
