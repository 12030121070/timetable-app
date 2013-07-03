class Workplace::BuildingsController < Workplace::WorkplaceController
  inherit_resources
  actions :all, except: [:show, :index]

  belongs_to :organization
end
