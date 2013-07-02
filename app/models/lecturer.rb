class Lecturer < ActiveRecord::Base
  attr_accessible :name, :patronymic, :surname

  belongs_to :organization

  def full_name
    "#{surname} #{name} #{patronymic}"
  end
  alias_method :to_s, :full_name
end
