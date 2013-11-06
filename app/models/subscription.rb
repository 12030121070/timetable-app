class Subscription < ActiveRecord::Base
  attr_accessible :ends_on, :groups_count, :starts_on, :month_count, :active
  attr_accessor :month_count

  belongs_to :organization
  before_create :set_dates, :set_groups_count, :set_sum

  scope :active, -> { where('active = :active', :active => true) }
  scope :actual, -> { where('starts_on <= :today AND ends_on >= :today', :today => Time.zone.today) }
  scope :by_ends_on, -> { order('ends_on ASC') }

  def change_active_state
    self.active = (active? ? false : true)
    self.save
  end

private
  def set_dates
    self.starts_on = Time.zone.today
    self.ends_on   = Time.zone.today + month_count.to_i.month
  end

  def set_groups_count
    self.groups_count = self.groups_count < tariff.min_group ? 5 : self.groups_count
  end

  def set_sum
    months_count = self.month_count.to_i
    groups_count = self.groups_count.to_i

    self.sum = tariff.choose_plan(months_count, groups_count)
  end

  def tariff
    Tariff.instance
  end
end
