class Manage::HolidaysController < Manage::ManageController
  inherit_resources

  has_scope :sorted, :default => 1

  actions :all, except: :show
end
