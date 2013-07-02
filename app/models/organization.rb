# encoding: utf-8

class Organization < ActiveRecord::Base
  attr_accessible :email, :phone, :site, :subdomain, :title

  has_many :memberships, :dependent => :destroy

  def set_owner(user)
    memberships.create! :user => user, :role => :owner
  end
end
