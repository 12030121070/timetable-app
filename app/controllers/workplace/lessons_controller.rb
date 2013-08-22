class Workplace::LessonsController < Workplace::WorkplaceController
  inherit_resources

  actions :all, except: [:show, :index]

  belongs_to :timetable, :week, :day

  custom_actions :resource => [:to_copy, :copy]

  def create
    create! do |success, failure|
      pdf_week = Pdf::Week.new(@week)
      @table = pdf_week.table_data
      pdf_week.set_colspans(@table)
      success.html {
        render :partial => 'workplace/weeks/week_timetable' and return
      }
    end
  end

  def update
    update! do |success, failure|
      pdf_week = Pdf::Week.new(@week)
      @table = pdf_week.table_data
      pdf_week.set_colspans(@table)
      success.html {
        render :partial => 'workplace/weeks/week_timetable' and return
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
