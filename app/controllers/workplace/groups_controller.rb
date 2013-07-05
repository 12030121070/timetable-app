class Workplace::GroupsController < Workplace::WorkplaceController
  inherit_resources

  actions :all, except: [:show, :index]

  belongs_to :organization, :timetable

  def create
    create!( :notice => "Dude! Nice job creating that group." ) { request.referer }
  end
end
