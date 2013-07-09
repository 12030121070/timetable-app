class Workplace::DisciplinesController < Workplace::WorkplaceController
  inherit_resources

  actions :all, except: :show

  belongs_to :organization, :finder => :find_by_subdomain!
end
