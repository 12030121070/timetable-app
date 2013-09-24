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
          :faculty_name => timetable.title,
          :faculty_id   => timetable.id,
          :date_start   => I18n.l(timetable.starts_on, :format => '%d.%m.%Y'),
          :date_end     => I18n.l(timetable.ends_on, :format => '%d.%m.%Y')
        }
      end
    end

    def get_groups_list(timetable_id)
      timetable = organization.published_timetables.find(timetable_id)
      timetable.groups.map do |group|
        {
          :group_name => group.title,
          :group_id   => group.id
        }
      end
    end

    def lessons_for_group(group)
      schedule = Set.new

      group.lessons.group_by{ |l| l.lesson_time.day }.each do |day, lessons|
        weekday_hash = {
          :weekday => day,
          :lessons => Set.new
        }

        lessons.group_by(&:discipline_title).each do |discipline_title, lessons|
          lesson_hash = { :subject => discipline_title }

          lessons.group_by(&:kind).each do |kind, lessons|
            lesson_hash[:type] = training_code(kind)

            lessons.group_by{ |l| l.lesson_time.starts_at }.each do |time_start, lessons|
              lesson_hash[:time_start] = time_start

              lessons.group_by{ |l| l.lesson_time.ends_at }.each do |time_end, lessons|
                lesson_hash[:time_end] = time_end

                lessons.group_by{ |l| l.lecturers.map{ |lecturer| { :teacher_name => lecturer.short_name.gsub('&nbsp;', ' ') } } }.each do |teachers, lessons|
                  lesson_hash[:teachers] = teachers

                  lessons.group_by{ |l| l.classrooms.includes(:building).map{|c| { auditory_name: c.to_s, auditory_address: c.building.address } } }.each do |auditories, lessons|
                    lesson_hash[:auditories] = auditories
                    lesson_hash[:parity]     = nil
                    lesson_hash[:date_start] = nil
                    lesson_hash[:date_end]   = nil
                    lesson_hash[:dates]      = lessons.map(&:day).map{|d| I18n.l(d.date, :format => '%d.%m.%Y')}.flatten
                  end
                end
              end
            end

          end

          weekday_hash[:lessons] << lesson_hash
        end

        schedule << weekday_hash
      end

      schedule
    end
  end

  rescue_from :all do |e|
    Airbrake.notify_or_ignore(e)
    Rack::Response.new(["rescued from #{e.class.name}"], 500, { "Content-type" => "text/error" }).finish
  end

  desc "Ping method"
  get :ping do
    :ok
  end

  desc 'Get faculties list'
  get :get_faculties do
    {
      :faculties => get_faculties_list
    }
  end

  desc 'Get groups list by faculty_id'
  params do
    requires :faculty_id, type: String, desc: "Timetable id"
  end
  get :get_groups do
    {
      :groups => get_groups_list(params[:faculty_id])
    }
  end

  desc 'Get group timetable'
  params do
    requires :group_id, type: String, desc: "Group id"
  end
  get :get_schedule do
    {
      :group_name => group(params[:group_id]).title,
      :days       => lessons_for_group(group(params[:group_id]))
    }
  end
end
