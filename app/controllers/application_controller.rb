class ApplicationController < ActionController::Base
  protect_from_forgery

  layout 'landing'

  def main_page
    redirect_to workplace_root_path if user_signed_in?
  end

private
  def after_sign_in_path_for(resource)
    workplace_root_url(:subdomain => false)
  end
end
