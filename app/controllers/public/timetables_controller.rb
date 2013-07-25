class Public::TimetablesController < ApplicationController
  inherit_resources

  actions :show

  belongs_to :organization, :finder => :find_by_subdomain
end
