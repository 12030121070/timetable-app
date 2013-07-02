class Lecturer < ActiveRecord::Base
  attr_accessible :name, :patronymic, :surname

  normalize_attributes :name, :patronymic, :surname
  validates_presence_of :name, :patronymic, :surname

  belongs_to :organization

  def full_name
    "#{surname} #{name} #{patronymic}"
  end
  alias_method :to_s, :full_name
end
