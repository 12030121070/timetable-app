class Public::LecturersController < Public::PublicController
  inherit_resources

  belongs_to :organization, :finder => :find_by_subdomain!

  action :show

  has_scope :published, :default => 1

  before_filter :set_subdomain

private
  def set_subdomain
    params.merge! :organization_id => request.subdomain
  end
end

