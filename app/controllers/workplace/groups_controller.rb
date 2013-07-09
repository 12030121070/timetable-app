class Workplace::GroupsController < Workplace::WorkplaceController
  inherit_resources

  actions :all, except: [:show, :index]

  belongs_to :organization, :finder => :find_by_subdomain!
  belongs_to :timetable

  def create
    create!( :notice => "Dude! Nice job creating that group." ) { request.referer }
  end
end
