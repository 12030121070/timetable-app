class Workplace::OrganizationsController < Workplace::WorkplaceController
  inherit_resources

  actions :show, :edit, :update

  def update
    update! { workplace_organization_path }
  end

  protected

  def begin_of_association_chain
    current_user
  end
end
