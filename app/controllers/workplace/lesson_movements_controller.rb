class Workplace::LessonMovementsController < Workplace::WorkplaceController
  inherit_resources

  actions :new, :create

  belongs_to :organization, :finder => :find_by_subdomain!
  belongs_to :timetable, :week, :day, :lesson

  defaults :resource_class => false

  def create
    create! do
      day, lesson_time = Day.find(params[:cell].split('_').first), LessonTime.find(params[:cell].split('_').last)
      @lesson.move_to day, lesson_time
      redirect_to [:workplace, @organization, @timetable, @week] and return
    end
  end

  protected

  def build_resource
  end

  def create_resource(object)
  end
end
