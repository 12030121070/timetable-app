# encoding: utf-8

class Classroom < ActiveRecord::Base
  attr_accessible :number

  belongs_to :building
end
