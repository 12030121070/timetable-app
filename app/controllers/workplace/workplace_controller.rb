class Workplace::WorkplaceController < ApplicationController
  layout ->(controller) { request.xhr? ? false : 'workplace' }

  before_filter :authenticate_user!
  before_filter :find_organization

  def index
    redirect_to workplace_timetables_path and return if current_user.has_organization?
  end

  protected

  def find_organization
    @organization = current_user.organization
  end

  def begin_of_association_chain
    @organization
  end
end
