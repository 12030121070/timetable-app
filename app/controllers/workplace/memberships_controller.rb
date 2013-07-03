class Workplace::MembershipsController < Workplace::WorkplaceController
  inherit_resources

  actions :all, :except => [:show, :index]

  belongs_to :organization

  private

  def resource_params
    @resource_params = [super.first.merge(:role => :member)]
  end
end
