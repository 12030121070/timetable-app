class Workplace::OrganizationsController < Workplace::WorkplaceController
  inherit_resources

  defaults :finder => :find_by_subdomain!

  actions :all, :except => [:index]

  def create
    create! {
      @organization.set_owner(current_user)
      redirect_to workplace_root_path and return
    }
  end

private
  def begin_of_association_chain
    @current_user = current_user
  end
end
