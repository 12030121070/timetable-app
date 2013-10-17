class Public::ClassroomsController < Public::PublicController
  inherit_resources

  belongs_to :organization, :finder => :find_by_subdomain!

  action :show, :index

  has_scope :page, :default => 1

  before_filter :set_subdomain

  def show
    show!{
      @weeks = @classroom.beginning_of_published_weeks
      @week = params[:week] ? params[:week] : @classroom.closest_published_week
      @table = @classroom.table_for(@week)
    }
  end

private
  def set_subdomain
    params.merge! :organization_id => request.subdomain
  end
end
