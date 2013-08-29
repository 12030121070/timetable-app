class Workplace::LessonCopiesController < Workplace::WorkplaceController
  inherit_resources

  actions :new, :create

  belongs_to :timetable, :week, :day, :lesson

  defaults :resource_class => false

  def create
    create! do
      params[:cells].each do |cell|
        day, lesson_time = Day.find(cell.split('_').first), LessonTime.find(cell.split('_').last)
        @lesson.copy_to day, lesson_time
      end

      pdf_week = Pdf::Week.new(@week)
      @table = pdf_week.table_data
      pdf_week.set_colspans(@table)

      render :partial => 'workplace/weeks/week_timetable', :notice => 'Урок скопирован.' and return
    end
  end

  protected

  def build_resource
  end

  def create_resource(object)
  end
end
