class Workplace::TimetablesController < Workplace::WorkplaceController
  inherit_resources

  actions :all, except: :show

  belongs_to :organization
end
