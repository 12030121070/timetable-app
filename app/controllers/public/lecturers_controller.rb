class Public::LecturersController < ApplicationController
  inherit_resources

  belongs_to :organization, :finder => :find_by_subdomain!

  action :show

  before_filter :set_subdomain

private
  def set_subdomain
    params.merge! :organization_id => request.subdomain
  end
end

