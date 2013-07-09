class Workplace::LessonsController < Workplace::WorkplaceController
  inherit_resources

  actions :all, except: [:show, :index]

  belongs_to :organization, :finder => :find_by_subdomain!
  belongs_to :timetable, :week, :day

  custom_actions :resource => [:to_copy, :copy]

  def create
    create! do
      flash[:alert] = @lesson.validation_message
      redirect_to [:workplace, @organization, @timetable, @week] and return
    end
  end

  def update
    update! { redirect_to [:workplace, @organization, @timetable, @week] and return }
  end

  def destroy
    destroy! { redirect_to [:workplace, @organization, @timetable, @week] and return }
  end
end
