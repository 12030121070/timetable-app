class Tariff < ActiveRecord::Base
  attr_accessible :cost, :discount_half_year, :discount_large, :discount_medium, :discount_small, :discount_year, :max_group, :max_month, :min_group, :min_month
  validates_presence_of :cost, :discount_half_year, :discount_large, :discount_medium, :discount_small, :discount_year, :max_group, :max_month, :min_group, :min_month

  def self.instance
    @@instance ||= (first || new)
  end


  def half_months
    max_month / 2
  end

  def half_groups
    max_group / 2
  end

  def first_plan
    cost
  end

  def second_plan
    cost - (cost * discount_half_year/100.0).round
  end

  def third_plan
    cost - (cost * discount_year/100.0).round
  end

  def fourth_plan
    cost - (cost * discount_medium/100.0).round
  end

  def fith_plan
    cost - (cost * discount_half_year/100.0).round - (cost * discount_medium/100.0).round
  end

  def sixth_plan
    cost - (cost * discount_year/100.0).round - (cost * discount_medium/100.0).round
  end

  def seventh_plan
    cost - (cost * discount_large/100.0).round
  end

  def eighth_plan
    cost - (cost * discount_half_year/100.0).round - (cost * discount_large/100.0).round
  end

  def nineth_plan
    cost - (cost * discount_year/100.0).round - (cost * discount_large/100.0).round
  end

  def as_json(options)
    super(:except => [:created_at, :updated_at, :id], :methods => [:first_plan, :second_plan, :third_plan, :fourth_plan, :fith_plan, :sixth_plan, :seventh_plan, :eighth_plan, :nineth_plan, :half_groups, :half_months])
  end
end
