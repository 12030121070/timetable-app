class Lecturer < ActiveRecord::Base
  attr_accessible :academic_degree, :academic_rank, :bio, :name, :patronymic, :photo, :surname

#  belongs_to :organization

  def full_name
    "#{surname} #{name} #{patronymic}"
  end
  alias_method :to_s, :full_name

  def academic_titles
    [academic_degree, academic_rank].delete_if(&:blank?).join(', ')
  end
end
