class Lecturer < ActiveRecord::Base
  attr_accessible :name, :patronymic, :surname

  belongs_to :organization

  has_many :lecturer_lessons, :dependent => :destroy
  has_many :lessons, :through => :lecturer_lessons

  validates_presence_of :name, :patronymic, :surname

  normalize_attributes :name, :patronymic, :surname

  def full_name
    "#{surname} #{name} #{patronymic}"
  end
  alias_method :to_s, :full_name
end
