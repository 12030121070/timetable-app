class Workplace::DisciplinesController < Workplace::WorkplaceController
  inherit_resources

  actions :all, except: :show

  def create
    create! do |success, failure|
      success.html { render :partial => 'discipline', :locals => { :discipline => resource } and return }
    end
  end

  def update
    update! do |success, failure|
      success.html { render :partial => 'discipline', :locals => { :discipline => resource } and return }
    end
  end
end
