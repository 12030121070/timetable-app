class Workplace::LessonCopiesController < Workplace::WorkplaceController
  inherit_resources

  actions :new, :create

  belongs_to :organization, :finder => :find_by_subdomain!
  belongs_to :timetable, :week, :day, :lesson

  defaults :resource_class => false

  def create
    create! do
      params[:cells].each do |cell|
        day, lesson_time = Day.find(cell.split('_').first), LessonTime.find(cell.split('_').last)
        @lesson.copy_to day, lesson_time
      end

      redirect_to [:workplace, @organization, @timetable, @week] and return
    end
  end

  protected

  def build_resource
  end

  def create_resource(object)
  end
end
