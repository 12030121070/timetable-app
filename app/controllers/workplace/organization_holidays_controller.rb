class Workplace::OrganizationHolidaysController < Workplace::WorkplaceController
  def update
    if @organization.update_attributes(params[:organization])
      redirect_to workplace_organization_path
    else
      render :edit
    end
  end
end
