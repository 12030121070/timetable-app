# encoding: utf-8

class Organization < ActiveRecord::Base
  attr_accessible :email, :phone, :site, :subdomain, :title

  validates_presence_of :email, :title, :subdomain
  validates_uniqueness_of :subdomain

  has_many :buildings, :dependent => :destroy, :order => 'buildings.title ASC'
  has_many :classrooms, :through => :buildings, :order => 'classrooms.number ASC'
  has_many :disciplines, :dependent => :destroy
  has_many :lecturers, :dependent => :destroy, :order => 'lecturers.surname ASC, lecturers.name ASC, lecturers.patronymic ASC'
  has_many :memberships, :dependent => :destroy
  has_many :timetables, :dependent => :destroy
  has_many :groups, :through => :timetables, :order => 'groups.title ASC'

  normalize_attributes :phone, :site, :subdomain, :title

  def set_owner(user)
    memberships.create! :user_id => user.id, :role => :owner
  end
end
