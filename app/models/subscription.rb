class Subscription < ActiveRecord::Base
  attr_accessible :ends_on, :groups_count, :starts_on, :month_count
  attr_accessor :month_count

  belongs_to :organization
  before_create :set_dates

private
  def set_dates
    self.starts_on = Time.zone.today
    self.ends_on   = Time.zone.today + month_count.to_i.month
  end
end
