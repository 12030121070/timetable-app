# encoding: utf-8

class Workplace::WeeksController < Workplace::WorkplaceController
  inherit_resources

  actions :all, except: [:index, :new, :edit]

  custom_actions :resource => :pdf

  belongs_to :organization, :finder => :find_by_subdomain!
  belongs_to :timetable

  def pdf
    pdf! {
      send_data @week.pdf.render, :type => 'application/pdf', :filename => 'week.pdf' and return
    }
  end
end
