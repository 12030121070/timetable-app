class Subscription < ActiveRecord::Base
  attr_accessible :ends_on, :groups_count, :starts_on, :month_count, :active
  attr_accessor :month_count

  belongs_to :organization
  before_create :set_dates

  def change_active_state
    self.active = (active? ? false : true)
    self.save
  end

private
  def set_dates
    self.starts_on = Time.zone.today
    self.ends_on   = Time.zone.today + month_count.to_i.month
  end
end
