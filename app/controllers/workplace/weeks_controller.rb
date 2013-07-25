# encoding: utf-8

class Workplace::WeeksController < Workplace::WorkplaceController
  inherit_resources

  actions :all, except: [:index, :new, :edit]

  custom_actions :resource => :pdf

  belongs_to :organization, :finder => :find_by_subdomain!
  belongs_to :timetable

  def pdf
    pdf! {
      send_data Pdf::Week.new(@week).render, :type => 'application/pdf', :filename => 'week.pdf', :disposition => :inline and return
    }
  end
end
