class Workplace::OrganizationsController < Workplace::WorkplaceController
  inherit_resources

  def create
    create! {
      @organization.set_owner(current_user)
      redirect_to workplace_root_path and return
    }
  end
end
