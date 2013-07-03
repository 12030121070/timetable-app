# encoding: utf-8

class Classroom < ActiveRecord::Base
  attr_accessible :number

  belongs_to :building

  validates_presence_of :number
  validates_uniqueness_of :number, :scope => :building_id

  normalize_attributes :number
end
