class Public::GroupsController < ApplicationController
  inherit_resources

  belongs_to :organization, :finder => :find_by_subdomain!
  defaults :finder => :find_by_title!

  action :show

  before_filter :set_subdomain

  def show
    show!{
      @week = params[:week] ? resource.weeks.find_by_starts_on(params[:week]) : resource.closest_week
      @table = resource.table_on(@week)
    }
  end

private
  def set_subdomain
    params.merge! :organization_id => request.subdomain
  end
end
