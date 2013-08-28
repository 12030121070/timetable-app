class Workplace::OrganizationsController < Workplace::WorkplaceController
  inherit_resources

  defaults :finder => :find_by_subdomain!

  actions :all, :except => :index

  def new
    new! {
      redirect_to workplace_root_path and return if current_user.has_organization?

      @organization = Organization.new
    }
  end

  def create
    redirect_to workplace_root_path and return if current_user.has_organization?

    create! do |success, failure|
      success.html { @organization.set_owner(current_user) }
    end
  end

  protected

  def begin_of_association_chain
    current_user
  end
end
