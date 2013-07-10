class Workplace::WorkplaceController < ApplicationController
  before_filter :authenticate_user!

  def index
    redirect_to workplace_organization_path(current_user.organization) and return if current_user.has_organization?

    @organizations = current_user.organizations
  end
end
