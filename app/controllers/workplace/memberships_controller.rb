class Workplace::MembershipsController < Workplace::WorkplaceController
  inherit_resources

  actions :all, :except => [:show, :edit, :update]

  protected

  def begin_of_association_chain
    @organization
  end

  def resource_params
    @resource_params = [super.first.merge(:role => :member)]
  end
end
