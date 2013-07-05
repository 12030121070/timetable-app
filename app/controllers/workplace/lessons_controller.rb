class Workplace::LessonsController < Workplace::WorkplaceController
  inherit_resources

  actions :all, except: [:show, :index]

  belongs_to :organization, :timetable, :week, :day

  def create
    create! { redirect_to [:workplace, @organization, @timetable, @week] and return }
  end

  def update
    update! { redirect_to [:workplace, @organization, @timetable, @week] and return }
  end
end
