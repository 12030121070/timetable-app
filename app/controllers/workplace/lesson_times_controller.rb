class Workplace::LessonTimesController < Workplace::WorkplaceController
  inherit_resources

  actions :all

  belongs_to :organization, :finder => :find_by_subdomain!
  belongs_to :timetable, :polymorphic => true

  layout false

  def destroy
    object = resource

    if object.last_in_day?
      destroy_resource object
      render :nothing => true
    else
      destroy_resource object
      render :text => "#{object.number} нет занятия в это время"
    end
  end
end
