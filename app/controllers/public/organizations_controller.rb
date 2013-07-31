class Public::OrganizationsController < ApplicationController
  inherit_resources

  defaults :finder => :find_by_subdomain!

  before_filter :set_params

  action :show

  def show
    show!{
      @groups = params.try(:[], :search).try(:[], :q).try(:present?) ? Group.search do
        fulltext params[:search][:q]
        with :timetable_status, :published
        with :organization_id, resource.id
        order_by :title, :asc
      end.results : []

      @lecturers = params.try(:[], :search).try(:[], :q).try(:present?) ? Lecturer.search do
        fulltext params[:search][:q]
        with :organization_id, resource.id
        order_by :full_name, :asc
      end.results : []
    }
  end

  def set_params
    params.merge! :id => request.subdomain
  end
end
