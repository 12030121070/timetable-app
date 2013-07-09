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

  normalize_attributes :phone, :site, :title
  normalize_attribute :subdomain, :with => [:strip] do |value|
    value.present? && value.is_a?(String) ? value.downcase : value
  end

  validate :format_of_domain

  def set_owner(user)
    memberships.create! :user_id => user.id, :role => :owner
  end

  def to_param
    subdomain
  end

private
  def format_of_domain
    errors.add(:subdomain, 'Wrong subdomain') unless self.subdomain.match(/\A[a-z0-9]+[a-z0-9-]+[a-z0-9]+\Z/)
  end
end
