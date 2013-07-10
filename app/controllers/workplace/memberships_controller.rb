class Workplace::MembershipsController < Workplace::WorkplaceController
  inherit_resources

  actions :all, :except => [:index, :show, :edit, :update]

  belongs_to :organization, :finder => :find_by_subdomain!

  private

  def resource_params
    @resource_params = [super.first.merge(:role => :member)]
  end
end
