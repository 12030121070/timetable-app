class Workplace::WorkplaceController < ApplicationController
  def index
    @organization = current_user.organization
  end
end
