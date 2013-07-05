class Day < ActiveRecord::Base
  attr_accessible :date, :status

  belongs_to :week

  delegate :wday, to: :date

  extend Enumerize
  enumerize :status, in: [:workday, :weekend, :holiday], predicates: true

  def day_name
    I18n.l(date, :format => '%a')
  end
end
