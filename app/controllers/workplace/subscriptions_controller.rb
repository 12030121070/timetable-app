class Workplace::SubscriptionsController < Workplace::WorkplaceController
  inherit_resources

  actions :index, :create

  before_filter :find_tariff

  private

  def find_tariff
    @tariff = Tariff.instance
  end

  protected

  def begin_of_association_chain
    @organization
  end
end
