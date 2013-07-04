class Day < ActiveRecord::Base
  attr_accessible :date, :status

  belongs_to :week

  extend Enumerize
  enumerize :status, in: [:workday, :weekend, :holiday], predicates: true
end
