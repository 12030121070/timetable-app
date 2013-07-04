class Workplace::TimetablesController < Workplace::WorkplaceController
  inherit_resources

  actions :all

  belongs_to :organization
end
