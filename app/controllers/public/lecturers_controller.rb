class Public::LecturersController < Public::PublicController
  inherit_resources

  belongs_to :organization, :finder => :find_by_subdomain!

  action :show

  has_scope :published, :default => 1

  before_filter :set_subdomain

  def show
    show! do |format|
      format.html {
        @weeks = @lecturer.beginning_of_published_weeks
        @week = params[:week] ? params[:week] : @lecturer.closest_published_week
        @table = @lecturer.table_for(@week)
      }

      format.ics {
        calendar = RiCal.Calendar do |cal|
          cal.prodid = "#{@organization.subdomain}.fliptable.ru"
          cal.default_tzid = "Asia/Novosibirsk"
          cal.add_date_times_to("Asia/Novosibirsk")
          resource.beginning_of_published_weeks.each do |week|
            @lecturer.table_for(week)[:lessons].each do |lesson_time, lessons_hash|
              lessons_hash.each do |date, lessons|
                lessons.each do |lesson|
                  cal.event do |event|
                    event.dtstart     = Time.zone.parse("#{date} #{lesson.lesson_time.starts_at}")
                    event.dtend       = Time.zone.parse("#{date} #{lesson.lesson_time.ends_at}")
                    event.summary     = lesson.discipline.title
                    event.location    = lesson.classrooms.join(', ')
                    event.description = "#{lesson.kind_text} , #{lesson.groups.map(&:title).join(', ').gsub('&nbsp;',' ')}"
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
