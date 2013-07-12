class Workplace::SubscriptionsController < Workplace::WorkplaceController
  inherit_resources

  actions :index, :new, :create

  belongs_to :organization, :finder => :find_by_subdomain!
end
