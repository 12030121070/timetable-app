class Workplace::MembershipsController < Workplace::WorkplaceController
  inherit_resources

  actions :all, :except => [:show, :edit, :update]

  def create
    create! do |success, failure|
      success.html { render :partial => 'membership', :locals => { :membership => resource } and return }
    end
  end

  def update
    update! do |success, failure|
      success.html { render :partial => 'membership', :locals => { :membership => resource } and return }
    end
  end

  protected

  def begin_of_association_chain
    @organization
  end

  def resource_params
    @resource_params = [super.first.merge(:role => :member)]
  end
end
