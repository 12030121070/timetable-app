class Manage::UsersController < Manage::ManageController
  def index
    @users = User.order('id ASC').all
  end
end
