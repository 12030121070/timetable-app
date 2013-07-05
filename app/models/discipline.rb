class Discipline < ActiveRecord::Base
  attr_accessible :abbr, :title, :organization

  belongs_to :organization
end
