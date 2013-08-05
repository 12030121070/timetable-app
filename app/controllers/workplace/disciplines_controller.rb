class Workplace::DisciplinesController < Workplace::WorkplaceController
  inherit_resources

  actions :all, except: :show

  protected

  def begin_of_association_chain
    @organization
  end
end
