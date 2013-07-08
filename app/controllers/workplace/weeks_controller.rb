# encoding: utf-8

class Workplace::WeeksController < Workplace::WorkplaceController
  inherit_resources

  actions :all, except: [:index, :new, :edit]

  belongs_to :organization, :timetable
end