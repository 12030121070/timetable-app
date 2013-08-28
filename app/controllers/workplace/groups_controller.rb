# encoding: utf-8

class Workplace::GroupsController < Workplace::WorkplaceController
  inherit_resources

  actions :all, except: [:show, :index]

  belongs_to :timetable

  def create
    create! do |success, failure|
      success.html { redirect_to request.referer, :notice => 'Группа успешно создана.' }
      failure.html { redirect_to request.referer, :alert => 'Ошибка при создании группы.' }
    end
  end

  def destroy
    destroy!(:notice => 'Группа удалена.') { request.referer }
  end
end
