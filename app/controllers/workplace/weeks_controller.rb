# encoding: utf-8

class Workplace::WeeksController < Workplace::WorkplaceController
  inherit_resources

  actions :all, except: [:new, :edit]

  belongs_to :organization, :timetable
end
