class Workplace::ClassroomsController < Workplace::WorkplaceController
  inherit_resources

  actions :show

  def show
    show! {
      beginning_of_week = params[:week] ? params[:week] : @classroom.beginning_of_weeks.first
      @table = @classroom.table(beginning_of_week)
    }
  end
end
