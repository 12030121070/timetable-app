class Subscription < ActiveRecord::Base
  attr_accessible :ends_on, :groups_count, :starts_on, :month_count, :active
  attr_accessor :month_count

  belongs_to :organization
  before_create :set_dates, :set_sum

  scope :actual, -> { where('active = :active AND starts_on <= :today AND ends_on >= :today', :active => true,  :today => Time.zone.today) }

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

    if groups_count >= tariff.min_group && groups_count < tariff.half_groups
      if month_count >= tariff.min_month && month_count < tariff.half_months
        total *= tariff.first_plan
      elsif month_count >= tariff.half_months && month_count < tariff.max_month
        total *= tariff.second_plan
      elsif month_count >= tariff.max_month
        total *= tariff.third_plan
      end
    elsif groups_count >= tariff.half_groups && groups_count < tariff.max_group
      if month_count >= tariff.min_month && month_count < tariff.half_months
        total *= tariff.fourth_plan
      elsif month_count >= tariff.half_months && month_count < tariff.max_month
        total *= tariff.fith_plan
      elsif month_count >= tariff.max_month
        total *= tariff.sixth_plan
      end
    elsif groups_count >= tariff.max_group
      if month_count >= tariff.min_month && month_count < tariff.half_months
        total *= tariff.seventh_plan
      elsif month_count >= tariff.half_months && month_count < tariff.max_month
        total *= tariff.eighth_plan
      elsif month_count >= tariff.max_month
        total *= tariff.nineth_plan
      end
    end

    self.sum = total
  end

  def tariff
    Tariff.instance
  end
end
