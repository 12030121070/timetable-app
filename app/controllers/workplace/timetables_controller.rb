class Workplace::TimetablesController < Workplace::WorkplaceController
  inherit_resources

  actions :all

  belongs_to :organization

  def to_published
    @timetable = Timetable.find(params[:id]) 
    @timetable.to_published
    redirect_to workplace_organization_timetable_path(@timetable)
  end

  def to_draft
    @timetable = Timetable.find(params[:id]) 
    @timetable.to_draft
    redirect_to workplace_organization_timetable_path(@timetable)
  end
end
