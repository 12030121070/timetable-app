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

  def short_name
    "#{surname.mb_chars.capitalize} #{name.first.mb_chars.capitalize}.#{patronymic.first.mb_chars.capitalize}."
  end
  alias_method :to_s, :short_name
end
