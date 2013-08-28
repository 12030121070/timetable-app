class Public::LecturersController < Public::PublicController
  inherit_resources

  belongs_to :organization, :finder => :find_by_subdomain!

  action :show

  has_scope :published, :default => 1

  before_filter :set_subdomain

  def show
    show! {
      @week = params[:week] ? params[:week] : @lecturer.beginning_of_published_weeks.first
      @table = @lecturer.table(@week)
    }
  end

private
  def set_subdomain
    params.merge! :organization_id => request.subdomain
  end
end

