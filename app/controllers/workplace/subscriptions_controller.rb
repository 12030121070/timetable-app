class Workplace::SubscriptionsController < Workplace::WorkplaceController
  inherit_resources

  actions :index, :new, :create

  before_filter :find_tariff, :only => :new

  private

  def find_tariff
    @tariff = Tariff.instance
  end
end
