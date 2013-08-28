# encoding: utf-8

class Organization < ActiveRecord::Base
  attr_accessible :email, :phone, :site, :subdomain, :title, :logotype,
    :organization_holidays_attributes, :lesson_times_attributes

  validates_presence_of :email, :title, :subdomain
  validates_uniqueness_of :subdomain

  has_many :buildings,             :dependent => :destroy, :order => 'buildings.title ASC'
  has_many :disciplines,           :dependent => :destroy, :order => 'disciplines.title ASC'
  has_many :lecturers,             :dependent => :destroy, :order => 'lecturers.surname ASC, lecturers.name ASC, lecturers.patronymic ASC'
  has_many :lesson_times,          :dependent => :destroy, :order => 'lesson_times.day ASC, lesson_times.number ASC, lesson_times.starts_at ASC', :as => :context
  has_many :memberships,           :dependent => :destroy, :order => 'memberships.id ASC'
  has_many :organization_holidays, :dependent => :destroy, :order => 'organization_holidays.date ASC'
  has_many :subscriptions,         :dependent => :destroy, :order => 'subscriptions.created_at ASC'
  has_many :timetables,            :dependent => :destroy, :order => 'timetables.starts_on ASC, timetables.created_at ASC'

  has_many :classrooms,             :through => :buildings,  :order => 'classrooms.number ASC'
  has_many :days,                   :through => :weeks,      :order => 'days.date ASC'
  has_many :groups,                 :through => :timetables, :order => 'groups.title ASC'
  has_many :published_weeks,        :through => :timetables, :order => 'weeks.number ASC, weeks.starts_on ASC', :conditions => "timetables.status = 'published'", :source => :weeks
  has_many :timetable_lesson_times, :through => :timetables, :order => 'timetables.starts_on ASC, timetables.created_at ASC', :source => :lesson_times
  has_many :weeks,                  :through => :timetables, :order => 'weeks.number ASC, weeks.starts_on ASC'

  accepts_nested_attributes_for :lesson_times, :allow_destroy => true
  accepts_nested_attributes_for :organization_holidays, :allow_destroy => true

  image_accessor :logotype
  validates_property :mime_type, :of => :logotype, :in => %w(image/png image/jpg image/jpeg)
  validates_property :width, :of => :logotype, :in => [128]
  validates_property :height, :of => :logotype, :in => [128]

  normalize_attributes :phone, :site, :title
  normalize_attribute :subdomain, :with => [:strip] do |value|
    value.present? && value.is_a?(String) ? value.downcase : value
  end

  before_validation :set_lesson_times_number
  validate :format_of_domain

  after_create :create_lesson_times

  def set_owner(user)
    memberships.create! :user_id => user.id, :role => :owner
  end

  def to_param
    subdomain
  end

  def holidays
    (organization_holidays.where('date >= ?', Time.zone.today) | Holiday.where('date >= ?', Time.zone.today)).sort_by(&:date)
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
    errors.add(:subdomain, 'Неверный домен') unless self.subdomain.match(/\A[a-z0-9]+[a-z0-9-]+[a-z0-9]+\Z/)
  end

  def set_lesson_times_number
    lesson_times.group_by(&:day).each do |day, lts|
      lts.select{|lt| lt.starts_at.present?}.sort_by{|lt| Time.zone.parse(lt.starts_at)}.each_with_index do |lt, index|
        lt.number = index+1
      end
    end
  end

  def create_lesson_times
    (1..6).each do |day|
      lesson_times.create :day => day, :number => 1, :starts_at =>  '8:50', :ends_at => '10:25'
      lesson_times.create :day => day, :number => 2, :starts_at => '10:40', :ends_at => '12:15'
      lesson_times.create :day => day, :number => 3, :starts_at => '13:15', :ends_at => '14:50'
      lesson_times.create :day => day, :number => 4, :starts_at => '15:00', :ends_at => '16:35'
      lesson_times.create :day => day, :number => 5, :starts_at => '16:45', :ends_at => '18:20'
      lesson_times.create :day => day, :number => 6, :starts_at => '18:30', :ends_at => '20:05'
      lesson_times.create :day => day, :number => 7, :starts_at => '20:15', :ends_at => '21:50'
    end
  end
end
