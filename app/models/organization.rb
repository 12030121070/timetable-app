# encoding: utf-8

class Organization < ActiveRecord::Base
  attr_accessible :email, :phone, :site, :subdomain, :title

  normalize_attributes :email, :phone, :site, :subdomain, :title
  validates_presence_of :email, :title, :subdomain
  validates_uniqueness_of :subdomain

  has_many :memberships, :dependent => :destroy
  has_many :lecturers, :dependent => :destroy
  has_many :buildings, :dependent => :destroy
  has_many :timetables, :dependent => :destroy

  def set_owner(user)
    memberships.create! :user_id => user.id, :role => :owner
  end
end
