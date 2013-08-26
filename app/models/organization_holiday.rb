class OrganizationHoliday < ActiveRecord::Base
  attr_accessible :date, :title

  belongs_to :organization

  validates_presence_of :date

  after_create :set_day_status

  after_destroy :reset_day_status

  private

  def set_day_status
    organization.days.where(:date => date).update_all :status => :holiday
  end

  def reset_day_status
    organization.days.where(:date => date).update_all :status => nil
  end
end
