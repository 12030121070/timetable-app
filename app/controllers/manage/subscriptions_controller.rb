class Manage::SubscriptionsController < Manage::ManageController
  inherit_resources

  actions :all, except: :show
  custom_actions :resource => :change_active_state

  belongs_to :organization, :finder => :find_by_subdomain!

  def change_active_state
    change_active_state! {
      @subscription.change_active_state
      redirect_to :action => :index and return
    }
  end
end
