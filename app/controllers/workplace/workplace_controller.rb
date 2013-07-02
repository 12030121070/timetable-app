class Workplace::WorkplaceController < ApplicationController
  def index
    @organization = current_user.organizations
  end
end
