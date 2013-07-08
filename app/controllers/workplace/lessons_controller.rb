class Workplace::LessonsController < Workplace::WorkplaceController
  inherit_resources

  actions :all, except: [:show, :index]

  belongs_to :organization, :timetable, :week, :day

  def create
    create! do
      flash[:alert] = @lesson.validation_message
      redirect_to [:workplace, @organization, @timetable, @week] and return
    end
  end

  def update
    update! { redirect_to [:workplace, @organization, @timetable, @week] and return }
  end
end
