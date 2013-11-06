class Tariff < ActiveRecord::Base
  attr_accessible :cost, :discount_large, :discount_medium, :discount_small, :max_group, :max_month, :min_group, :min_month
  validates_presence_of :cost, :discount_large, :discount_medium, :discount_small, :max_group, :max_month, :min_group, :min_month

  def self.instance
    (first || new)
  end

  def choose_plan(month_count, group_count)
    return 0 if group_count < min_group
    month_count*group_count*(cost - (cost*discount(month_count, group_count)).round)
  end

  def discount(month_count, group_count)
    month_index = index_member_of('months', month_count)
    group_index = index_member_of('groups', group_count)

    (month_discount(month_index)+group_discount(group_index))/100.0
  end

  def month_discount(month_index)
    discount_hash[month_index]
  end

  def group_discount(group_index)
    discount_hash[group_index]
  end

  def as_json(options)
    super(:except => [:created_at, :updated_at, :id], :methods => [:divide_by, :discount_hash, :max_month, :min_month, :max_group, :min_group, :cost])
  end

  def discount_hash
    {
      1 => 0,
      2 => discount_small,
      3 => discount_medium,
      4 => discount_large,
    }
  end

  def divide_by
    4
  end

  def index_member_of(kind, item)
    max = case kind
      when 'months'
        max_month
      when 'groups'
        max_group
    end
    arr = splitted_range((1..max))
    arr.each_with_index do |items, index|
      return index+1 if items.include?(item == max ? item : item + 1)
    end
  end

  def splitted_range(range)
    range.each_slice((range.count/divide_by.to_f).round).to_a
  end
end
