class Workplace::LessonsController < Workplace::WorkplaceController
  inherit_resources

  actions :all, except: [:show, :index]

  belongs_to :timetable, :week, :day

  custom_actions :resource => [:to_copy, :copy]

  def create
    create! do |success, failure|
      success.html { render :partial => 'lesson', :locals => { :lesson => resource } and return }
    end
  end

  def update
    update! do |success, failure|
      success.html { render :partial => 'lesson', :locals => { :lesson => resource } and return }
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
