class Public::GroupsController < Public::PublicController
  inherit_resources

  belongs_to :organization, :finder => :find_by_subdomain!
  defaults :finder => :find_by_title!

  action :show
  has_scope :published, :default => 1

  before_filter :set_subdomain

  def show
    show!{
      @week = params[:week] ? resource.published_weeks.find_by_starts_on(params[:week]) : resource.closest_week
      @table = @group.table_for(@week.starts_on)
    }
  end

private
  def set_subdomain
    params.merge! :organization_id => request.subdomain
  end
end
