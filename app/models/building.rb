# encoding: utf-8

class Building < ActiveRecord::Base
  attr_accessible :address, :title, :classrooms_attributes

  belongs_to :organization
  has_many :classrooms, :dependent => :destroy

  accepts_nested_attributes_for :classrooms, allow_destroy: true
end
