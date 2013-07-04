class Week < ActiveRecord::Base
  attr_accessible :number, :starts_on, :parity

  belongs_to :timetable

  has_many :days

  extend Enumerize
  enumerize :parity, in: [:odd, :even], predicates: true
  
  scope :even, -> { where(parity: :even) }
  scope :odd, -> { where(parity: :odd) }
end
