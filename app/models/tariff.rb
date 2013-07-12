class Tariff < ActiveRecord::Base
  attr_accessible :cost, :discount_half_year, :discount_large, :discount_medium, :discount_small, :discount_year, :max_group, :max_month, :min_group, :min_month
  validates_presence_of :cost, :discount_half_year, :discount_large, :discount_medium, :discount_small, :discount_year, :max_group, :max_month, :min_group, :min_month

  def self.instance
    @@instance ||= (first || new)
  end
end
