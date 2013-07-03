class Timetable < ActiveRecord::Base
  attr_accessible :ends_on, :parity, :starts_on, :status, :title
  belongs_to :organization

  extend Enumerize
  enumerize :status, in: [:draft, :published], predicates: true

  validates_presence_of :title, :starts_on, :ends_on
end
