class Public::OrganizationsController < ApplicationController
  inherit_resources

  defaults :finder => :find_by_subdomain!

  before_filter :set_params

  action :show

  def set_params
    params.merge! :id => request.subdomain
  end
end
