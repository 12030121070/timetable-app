class API < Grape::API
  prefix 'api'
  format :json

  helpers do
    def subdomain
      request.host.match(/\A.+(?=\..+\..+\z)/).to_s
    end

    def organization
      @organization ||= Organization.find_by_subdomain(subdomain)
    end

    def group(id)
      organization.published_groups.find(id)
    end

    def training_code(kind)
      {
        "lecture" => 2,
        "practice" => 0,
        "laboratory" => 1,
        "research" => 4,
        "design" => 4,
        "test" => 6,
        "exam" => 7
      }[kind]
    end

    def get_faculties_list
      organization.published_timetables.map do |timetable|
        {
          faculty_name: timetable.title,
          faculty_id:   timetable.id,
          date_start:   I18n.l(timetable.starts_on, :format => '%d.%m.%Y'),
          date_end:     I18n.l(timetable.ends_on, :format => '%d.%m.%Y')
        }
      end
    end

    def get_groups_list(timetable_id)
      timetable = organization.published_timetables.find(timetable_id)
      timetable.groups.map do |group|
        {
          group_name: group.title,
          group_id:   group.id
        }
      end
    end

    def lessons_for_group(group)
      schedule = []
      group.published_weeks.each do |week|
        group.table_for(week.starts_on)[:lessons].each do |lesson_time, lessons_hash|
          lessons_hash.each do |date, lessons|
            lessons.each do |lesson|
              if schedule.select{|s| s['weekday'] == lesson.lesson_time.day.to_s }.empty?
                schedule << { 'weekday' => lesson.lesson_time.day.to_s }
              end

              schedule.map! do |item|
                if item['weekday'] == lesson.lesson_time.day.to_s
                  item['lessons'] ||= []
                  item['lessons'] << {
                    subject:      lesson.discipline.title,
                    type:         training_code(lesson.kind),
                    time_start:   lesson.lesson_time.starts_at,
                    time_end:     lesson.lesson_time.ends_at,
                    parity:       nil,
                    date_start:   nil,
                    date_end:     nil,
                    dates:        [I18n.l(Time.zone.parse(date), :format => '%d.%m.%Y')],
                    teachers:     lesson.lecturers.map{|l| { teacher_name: l.short_name.gsub('&nbsp;', ' ') } },
                    auditoriums:  lesson.classrooms.map{|c| { auditory_name: c.to_s, auditory_address: c.building.address }}
                  }
                end
                item
              end
            end
          end
        end
      end
      schedule
    end
  end

  #rescue_from :all do |e|
    #Airbrake.notify_or_ignore(e)
    #Rack::Response.new(["rescued from #{e.class.name}"], 500, { "Content-type" => "text/error" }).finish
  #end

  desc "Ping method"
  get :ping do
    :ok
  end

  desc 'Get faculties list'
  get :get_faculties do
    {
      faculties: get_faculties_list
    }
  end

  desc 'Get groups list by faculty_id'
  params do
    requires :faculty_id, type: String, desc: "Timetable id"
  end
  get :get_groups do
    {
      groups: get_groups_list(params[:faculty_id])
    }
  end

  desc 'Get group timetable'
  params do
    requires :group_id, type: String, desc: "Group id"
  end
  get :get_schedule do
    {
      group_name: group(params[:group_id]).title,
      days: lessons_for_group(group(params[:group_id]))
    }
  end
end
