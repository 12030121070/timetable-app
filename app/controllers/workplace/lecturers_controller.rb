class Workplace::LecturersController < Workplace::ApplicationController
  inherit_resources
  actions :all, except: :show

  belongs_to :organization
end
