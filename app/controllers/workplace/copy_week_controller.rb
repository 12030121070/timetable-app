class Workplace::CopyWeekController < Workplace::WorkplaceController
  inherit_resources
  before_filter :find_parents

  def new
    @recipients = @timetable.weeks - [@week]
  end

  def create
    begin
      recipients = @timetable.weeks.find(params[:recipients])
      @week.copy_to(recipients)
      flash[:notice] = 'Занятия успешно скопированы.'
    rescue => e
      logger.error "ERROR: #{e}"
      flash[:alert] = 'Во время копирования произошла ошибка.'
    end

    redirect_to request.referer
  end

  private

  def find_parents
    @timetable    = @organization.timetables.find(params[:timetable_id])
    @week         = @timetable.weeks.find(params[:week_id])
  end
end
