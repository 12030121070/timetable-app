class Workplace::SubscriptionsController < Workplace::WorkplaceController
  inherit_resources

  actions :index, :new, :create

  belongs_to :organization, :finder => :find_by_subdomain!
  before_filter :find_tariff, :only => :new

private
  def find_tariff
    @tariff = Tariff.instance
  end
end
