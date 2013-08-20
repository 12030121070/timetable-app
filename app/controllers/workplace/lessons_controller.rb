class Workplace::LessonsController < Workplace::WorkplaceController
  inherit_resources

  actions :all, except: [:show, :index]

  belongs_to :timetable, :week, :day

  custom_actions :resource => [:to_copy, :copy]

  def create
    create! do |success, failure|
      @sibling = @day.lessons.find_by_id(params[:lesson][:sibling_id])
      success.html {
        render :partial => 'workplace/weeks/cell', :locals => { :cell => Pdf::Cell.new(:day => resource.day, :lesson_time => resource.lesson_time, :lessons => [resource, @sibling].compact) } and return
      }
    end
  end

  def update
    update! do |success, failure|
      @sibling = @day.lessons.find_by_id(params[:lesson][:sibling_id])
      success.html {
        render :partial => 'workplace/weeks/cell', :locals => { :cell => Pdf::Cell.new(:day => resource.day, :lesson_time => resource.lesson_time, :lessons => [resource, @sibling].compact) } and return
      }
    end
  end

  def destroy
    destroy! { redirect_to [:workplace, @timetable, @week] and return }
  end

  protected

  def begin_of_association_chain
    @organization
  end
end
