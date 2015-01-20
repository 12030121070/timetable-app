require 'progress_bar'
require 'open-uri'

desc "Import lessons form tusur.timetable"
task :import => :environment do
  #create_tariff
  create_subscription
  create_lesson_times
  create_timetables
end

#def create_tariff
  #Tariff.destroy_all

  #Tariff.create! :min_month => 1, :max_month => 12,
    #:min_group => 5, :max_group => 200,
    #:cost => 100,
    #:discount_small => 5, :discount_medium => 10, :discount_large => 15
#end

def create_subscription
  organization.subscriptions.create! :month_count => 12, :groups_count => 100, :active => true
end

def create_lesson_times
  (1..6).each do |day|
    organization.lesson_times.create :day => day, :number => 1, :starts_at =>  '8:50', :ends_at => '10:25'
    organization.lesson_times.create :day => day, :number => 2, :starts_at => '10:40', :ends_at => '12:15'
    organization.lesson_times.create :day => day, :number => 3, :starts_at => '13:15', :ends_at => '14:50'
    organization.lesson_times.create :day => day, :number => 4, :starts_at => '15:00', :ends_at => '16:35'
    organization.lesson_times.create :day => day, :number => 5, :starts_at => '16:45', :ends_at => '18:20'
    organization.lesson_times.create :day => day, :number => 6, :starts_at => '18:30', :ends_at => '20:05'
    organization.lesson_times.create :day => day, :number => 7, :starts_at => '20:15', :ends_at => '21:50'
  end
end

def create_timetables
  bar = ProgressBar.new(faculties.count*courses.count*(period.first..period.last).count)

  organization.timetables.destroy_all
  organization.lecturers.destroy_all
  organization.buildings.destroy_all
  organization.disciplines.destroy_all

  faculties.each do |faculty|
    courses.each do |course|
      timetable = organization.timetables.create(:title => "#{faculty} #{course} курс", :parity => true, :first_week_parity => :odd, :starts_on => period.first, :ends_on => period.last)
      timetable.publish

      remote_groups.select{|group| group['course'] == course && group['faculty_name'] == faculty}[0..4].each do |group|
        timetable.groups.create! :title => group['number']
      end

      timetable.weeks.each do |week|
        week.days.each do |day|
          date = day.date.to_s
          bar.increment!

          timetable.groups.each do |group|
            remote_lessons = JSON.parse(open("https://timetable.tusur.ru/api/v1/timetables/#{group.title}/#{date}").read)['lessons']
            remote_lessons.each do |remote_lesson|
              discipline = organization.disciplines.find_or_create_by_title(remote_lesson['discipline']['title'])
              next if day.date.cwday > 6

              lesson_time = timetable.lesson_times.for_day(day.date.cwday).for_number(remote_lesson['order_number']).first
              local_lesson = day.lessons.find_or_create_by_discipline_id_and_kind_and_lesson_time_id :kind => remote_lesson['kind'], :discipline_id => discipline.id, :lesson_time_id => lesson_time.id
              local_lesson.groups << group

              remote_lesson['lecturers'].each do |remote_lecturer|
                lecturer = organization.lecturers.find_or_create_by_name_and_patronymic_and_surname(:surname => remote_lecturer['lastname'].squish, :name => remote_lecturer['firstname'].squish, :patronymic => remote_lecturer['middlename'].squish)
                local_lesson.lecturers << lecturer unless local_lesson.lecturers.include?(lecturer)
              end

              remote_building, remote_classroom = remote_lesson['classroom'].split(' ')
              building = organization.buildings.find_or_create_by_address_and_title(:address => 'г.Томск', :title => remote_building)
              begin
                classroom = building.classrooms.find_or_create_by_number(remote_classroom)
                local_lesson.classrooms << classroom unless local_lesson.classrooms.include?(classroom)
              rescue Exception => e
                puts e.message
              end
            end
          end
        end
      end
    end
  end
end

def remote_groups
  @remote_groups ||= JSON.parse(open('https://timetable.tusur.ru/api/v1/groups/internal.json').read)['groups'].select{|item| faculties.include?(item['faculty_name']) && courses.include?(item['course'])}
end

def faculties
  ['Радиоконструкторский факультет', 'Факультет электронной техники', 'Факультет систем управления']
end

def courses
  [1, 3]
end

def period
  [Time.zone.parse('2015-01-05').beginning_of_week.to_date, Time.zone.parse('2015-08-01').end_of_week.to_date]
end

def organization
  @organization ||= Organization.find_by_subdomain!('demo')
end
