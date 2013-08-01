class Manage::ManageController < ApplicationController
  layout 'manage'

  before_filter :authenticate_user!
end
