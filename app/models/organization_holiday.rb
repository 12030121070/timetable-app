class OrganizationHoliday < ActiveRecord::Base
  attr_accessible :date

  belongs_to :organization
end
