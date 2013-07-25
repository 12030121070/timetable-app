class Subscription < ActiveRecord::Base
  attr_accessible :ends_on, :groups_count, :starts_on, :month_count, :active
  attr_accessor :month_count

  belongs_to :organization
  before_create :set_dates, :set_sum

  scope :actual, -> { where('starts_on <= :today AND ends_on >= :today', :today => Time.zone.today) }

  def change_active_state
    self.active = (active? ? false : true)
    self.save
  end

private
  def set_dates
    self.starts_on = Time.zone.today
    self.ends_on   = Time.zone.today + month_count.to_i.month
  end

  def set_sum
    month_count = self.month_count.to_i
    total = month_count * groups_count

    if month_count >= tariff.min_month && month_count < tariff.half_months && group_count >= tariff.min_group && group_count < tariff.half_groups
      total *= tariff.first_plan
    elsif month_count >= tariff.half_months && month_count < tariff.max_months && group_count >= tariff.min_group && group_count < tariff.half_groups
      total *= tariff.second_plan
    elsif month_count >= tariff.max_month && group_count >= tariff.min_group && group_count < tariff.half_groups
      total *= tariff.third_plan
    elsif month_count >= tariff.min_month && month_count < tariff.half_months && group_count >= tariff.half_groups && group_count < tariff.max_group
      total *= tariff.fourth_plan
    elsif month_count >= tariff.half_months && month_count < tariff.max_months && group_count >= tariff.half_groups && group_count < tariff.max_group
      total *= tariff.fith_plan
    elsif month_count >= tariff.max_months && group_count >= tariff.half_groups && group_count < tariff.max_group
      total *= tariff.sixth_plan
    elsif month_count >= tariff.min_month && group_count < tariff.half_months && group_count >= tariff.half_groups && group_count < tariff.max_group
      total *= tariff.seventh_plan
    elsif month_count >= tariff.half_months && group_count < tariff.max_months && group_count >= tariff.half_groups && group_count < tariff.max_group
      total *= tariff.eighth_plan
    elsif month_count >= tariff.max_month && group_count >= tariff.half_groups && group_count < tariff.max_group
      total *= tariff.nineth_plan
    end

    self.sum = total
  end

  def tariff
    Tariff.instance
  end
end
