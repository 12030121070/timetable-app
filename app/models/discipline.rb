class Discipline < ActiveRecord::Base
  attr_accessible :abbr, :title
  belongs_to :organization
end
