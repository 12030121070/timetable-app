class Day < ActiveRecord::Base
  attr_accessible :date, :status
  delegate :wday, to: :date

  belongs_to :week

  has_many :lessons, :dependent => :destroy

  extend Enumerize
  enumerize :status, in: [:workday, :weekend, :holiday], predicates: true

  def day_name
    I18n.l(date, :format => '%a')
  end
end
