class Manage::SubscriptionsController < Manage::ManageController
  inherit_resources

  actions :all, except: :show

  belongs_to :organization, :finder => :find_by_subdomain!
end
