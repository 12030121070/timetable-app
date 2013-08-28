class User < ActiveRecord::Base
  attr_accessible :email, :password, :remember_me

  has_many :memberships, :dependent => :destroy
  has_many :organizations, :through => :memberships

  devise :database_authenticatable, :registerable, :recoverable,
    :rememberable, :trackable, :validatable, :confirmable, :async

  normalize_attributes :email

  after_create :activate_memberships
  after_create :create_organization, :unless => :has_organization?

  def has_organization?
    memberships.joins(:organization).any?
  end

  def organization
    Organization.where(:id => memberships.pluck(:organization_id)).limit(1).first
  end

  def owner_of?(organization)
    memberships.joins(:organization).where('organizations.id' => organization.id).any?
  end

  private

  def activate_memberships
    Membership.inactive.where(:email => email).each { |membership|
      membership.update_attributes :user_id => id, :email => nil
    }
  end

  def create_organization
    organization = Organization.new
    organization.save(:validate => false)
    organization.set_owner self

    true
  end
end
