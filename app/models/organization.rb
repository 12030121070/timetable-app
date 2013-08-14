# encoding: utf-8

class Organization < ActiveRecord::Base
  attr_accessible :email, :phone, :site, :subdomain, :title, :organization_holidays_attributes, :logotype

  validates_presence_of :email, :title, :subdomain
  validates_uniqueness_of :subdomain

  has_many :buildings, :dependent => :destroy, :order => 'buildings.title ASC'
  has_many :classrooms, :through => :buildings, :order => 'classrooms.number ASC'
  has_many :disciplines, :dependent => :destroy, :order => 'disciplines.title ASC'
  has_many :lecturers, :dependent => :destroy, :order => 'lecturers.surname ASC, lecturers.name ASC, lecturers.patronymic ASC'
  has_many :memberships, :dependent => :destroy, :order => 'memberships.id ASC'
  has_many :timetables, :dependent => :destroy, :order => 'timetables.starts_on ASC, timetables.created_at ASC'
  has_many :lesson_times, :through => :timetables, :order => 'lesson_times.day ASC, lesson_times.number ASC, lesson_times.starts_at ASC'
  has_many :weeks, :through => :timetables, :order => 'weeks.number ASC, weeks.starts_on ASC'
  has_many :published_weeks, :through => :timetables, :order => 'weeks.number ASC, weeks.starts_on ASC', :conditions => "timetables.status = 'published'", :source => :weeks
  has_many :groups, :through => :timetables, :order => 'groups.title ASC'
  has_many :organization_holidays, :dependent => :destroy
  has_many :subscriptions, :dependent => :destroy, :order => 'subscriptions.created_at ASC'

  accepts_nested_attributes_for :organization_holidays, :allow_destroy => true

  image_accessor :logotype
  validates_property :mime_type, :of => :logotype, :in => %w(image/png image/jpg image/jpeg)
  validates_property :width, :of => :logotype, :in => [128]
  validates_property :height, :of => :logotype, :in => [128]

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

  def holidays
    organization_holidays.map(&:date) | Holiday.all.map(&:date)
  end

  def available_group_count
    groups_count_by_subscriptions - groups_count_by_published_timetables
  end

  def groups_count_by_published_timetables
    timetables.with_status(:published).map{|t| t.groups.count}.sum
  end

  def groups_count_by_subscriptions
    return 5 if subscriptions.empty?

    subscriptions.actual.sum(:groups_count)
  end

private
  def format_of_domain
    errors.add(:subdomain, 'Wrong subdomain') unless self.subdomain.match(/\A[a-z0-9]+[a-z0-9-]+[a-z0-9]+\Z/)
  end
end
