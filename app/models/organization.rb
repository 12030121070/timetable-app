# encoding: utf-8

class Organization < ActiveRecord::Base
  attr_accessible :email, :phone, :site, :subdomain, :title
end
