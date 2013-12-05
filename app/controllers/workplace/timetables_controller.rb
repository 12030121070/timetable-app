# encoding: utf-8

class Workplace::TimetablesController < Workplace::WorkplaceController
  inherit_resources

  actions :all, :except => [:show]

  custom_actions :resource => [:to_draft, :to_published, :statistics]

  def to_published
    to_published! {
      @timetable = @organization.timetables.find(params[:id])

      begin
        @timetable.publish!
        flash[:notice] = 'Расписание опубликовано.'
      rescue => e
        logger.error "ERROR: #{e}"
        flash[:alert] = 'Вы не можете опубликаовать расписание, вам необходимо расширить вашу подписку.'
      end

      render :partial => 'workplace/weeks/head_of_timetable', :locals => { :flash => flash } and return
    }
  end

  def to_draft
    to_draft! {
      @timetable = @organization.timetables.find(params[:id])

      begin
        @timetable.unpublish!
        flash[:notice] = 'Расписание переведено в состояние черновика.'
      rescue => e
        logger.error "ERROR: #{e}"
        flash[:alert] = 'Расписание уже находится в состоянии черновика.'
      end

      render :partial => 'workplace/weeks/head_of_timetable', :locals => { :flash => flash } and return
    }
  end

  def statistics
    statistics! { @statistics = TimetableStatistics.new(@timetable) }
  end

  def create
    create! do |success, failure|
      success.html { render :partial => 'timetable', :locals => { :timetable => resource } and return }
    end
  end

  def update
    update! do |success, failure|
      success.html { render :partial => 'timetable', :locals => { :timetable => resource } and return }
    end
  end

  protected

  def begin_of_association_chain
    @organization
  end
end
