class Public::OrganizationsController < Public::PublicController
  inherit_resources

  defaults :finder => :find_by_subdomain!

  before_filter :set_params

  action :show

  def show
    @organization = Organization.find_by_subdomain!(params[:id])

    @groups = params.try(:[], :term).try(:present?) ? Group.search do
      fulltext params[:term]
      with :timetable_status, :published
      with :organization_id, resource.id
      order_by :title, :asc
    end.results : []

    @lecturers = params.try(:[], :term).try(:present?) ? Lecturer.search do
      fulltext params[:term]
      with :organization_id, resource.id
      with(:published_lessons_count).greater_than(0)
      order_by :full_name, :asc
    end.results : []

    results = @groups + @lecturers
    respond_to do |format|
      format.html
      format.json {
        render :json => results.map{|r| { :label => r.title, :value => r.title } } and return
      }
    end
  end

  def set_params
    params.merge! :id => request.subdomain
  end
end
