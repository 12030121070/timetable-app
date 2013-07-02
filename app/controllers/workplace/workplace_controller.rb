class Workplace::WorkplaceController < ApplicationController
  before_filter :authenticate_user!

  def index
    @organizations = current_user.organizations
  end
end
