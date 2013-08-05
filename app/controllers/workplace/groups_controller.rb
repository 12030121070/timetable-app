class Workplace::GroupsController < Workplace::WorkplaceController
  inherit_resources

  actions :all, except: [:show, :index]

  belongs_to :timetable

  def create
    create!( :notice => "Dude! Nice job creating that group." ) { request.referer }
  end

  protected

  def begin_of_association_chain
    @organization
  end
end
