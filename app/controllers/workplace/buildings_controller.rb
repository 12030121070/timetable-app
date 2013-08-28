# encoding: utf-8

require 'importers/csv_import'

class Workplace::BuildingsController < Workplace::WorkplaceController
  inherit_resources

  actions :all, except: [:show]

  custom_actions :collection => :import

  def import
    import! {
      file = params[:import][:file] if params[:import]

      begin
        CsvImport.new(file.tempfile.path, collection.new).import
        flash[:notice] = 'Импорт прошел успешно.'
      rescue => e
        logger.error "ERROR: #{e}"
        flash[:alert] = 'Во время импорта произошла ошибка.'
      end

      redirect_to workplace_buildings_path and return
    }
  end

  def create
    create! do |success, failure|
      success.html { render :partial => 'building', :locals => { :building => resource } and return }
    end
  end

  def update
    update! do |success, failure|
      success.html { render :partial => 'building', :locals => { :building => resource } and return }
    end
  end
end
