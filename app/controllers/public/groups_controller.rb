class Public::GroupsController < Public::PublicController
  inherit_resources

  belongs_to :organization, :finder => :find_by_subdomain!
  defaults :finder => :find_by_title!

  action :show
  has_scope :published, :default => 1

  before_filter :set_subdomain

  def show
    show! do |format|
      format.html {
        @weeks = resource.published_weeks
        @week = params[:week] ? @weeks.find_by_starts_on(params[:week]) : resource.closest_week
        @table = @group.table_for(@week.starts_on)
      }
      format.ics {
        calendar = RiCal.Calendar do |cal|
          cal.prodid = "#{@organization.subdomain}.fliptable.ru"
          cal.default_tzid = "Asia/Novosibirsk"
          cal.add_date_times_to("Asia/Novosibirsk")
          resource.published_weeks.each do |week|
            @group.table_for(week.starts_on)[:lessons].each do |lesson_time, lessons_hash|
              lessons_hash.each do |date, lessons|
                lessons.each do |lesson|
                  cal.event do |event|
                    event.dtstart     = Time.zone.parse("#{date} #{lesson.lesson_time.starts_at}")
                    event.dtend       = Time.zone.parse("#{date} #{lesson.lesson_time.ends_at}")
                    event.summary     = lesson.discipline.title
                    event.location    = lesson.classrooms.join(', ')
                    event.description = "#{lesson.kind_text} , #{lesson.lecturers.join(', ').gsub('&nbsp;',' ')}"
                  end
                end
              end
            end
          end
        end
        render :text => calendar and return
      }
    end
  end

private
  def set_subdomain
    params.merge! :organization_id => request.subdomain
  end
end
