# encoding: utf-8

class Workplace::LogosController < Workplace::WorkplaceController
  inherit_resources
  defaults :singleton => true
  actions :create, :destroy

  def create
    create! do |success, failure|
      success.html { redirect_to workplace_organization_path, :notice => 'Логотип успешно сохранен.' and return }
      failure.html { redirect_to workplace_organization_path, :alert => "Ошибка при загрузке картинки (#{resource.errors.messages.values.join(', ')})." and return }
    end
  end

protected
  def begin_of_association_chain
    @organization
  end

  def root_url
    workplace_organization_path
  end
end
