# encoding: utf-8

require 'importers/csv_import'

class Workplace::LecturersController < Workplace::WorkplaceController
  inherit_resources

  actions :all, :except => [:show]

  custom_actions :collection => :import

  def edit
    edit!{
      beginning_of_week = params[:week] ? params[:week] : @lecturer.beginning_of_weeks.first
      @table = @lecturer.table(beginning_of_week)
    }
  end

  def import
    import! {
      file = params[:import][:file] if params[:import]

      begin
        CsvImport.new(file.tempfile.path, collection.new).import
        flash[:notice] = 'Импорт прошел успешно'
      rescue => e
        logger.error "ERROR: #{e}"
        flash[:alert] = 'Во время импорта произошла ошибка'
      end

      redirect_to workplace_lecturers_path and return
    }
  end

  def create
    create! do |success, failure|
      success.html { render :partial => 'lecturer', :locals => { :lecturer => resource } and return }
    end
  end

  def update
    update! do |success, failure|
      success.html { render :partial => 'lecturer', :locals => { :lecturer => resource } and return }
    end
  end

protected
  def begin_of_association_chain
    @organization
  end
end
