class Manage::ManageController < ApplicationController
  before_filter :authenticate_user!
end
