# encoding: utf-8

class Building < ActiveRecord::Base
  attr_accessible :address, :title

  belongs_to :organization
  has_many :classrooms, :dependent => :destroy
end
