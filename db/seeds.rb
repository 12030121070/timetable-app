# encoding: utf-8

user = User.find_or_initialize_by_email('demo@demo.de') do |u|
  u.password = 'demodemo'
  u.skip_confirmation!
  u.save!
end

organization = user.organizations.find_or_initialize_by_title('Томский Государственный Университет Систем Управления и Радиоэлектроники') do |o|
  o.email = 'mail@tusur.ru'
  o.phone = '(3822) 51-05-30'
  o.site = 'http://tusur.ru'
  o.subdomain = 'tusur'
  o.save!
  o.set_owner(user)
end

(1..6).each do |day|
  organization.lesson_times.create :day => day, :number => 1, :starts_at =>  '8:50', :ends_at => '10:25'
  organization.lesson_times.create :day => day, :number => 2, :starts_at => '10:40', :ends_at => '12:15'
  organization.lesson_times.create :day => day, :number => 3, :starts_at => '13:15', :ends_at => '14:50'
  organization.lesson_times.create :day => day, :number => 4, :starts_at => '15:00', :ends_at => '16:35'
  organization.lesson_times.create :day => day, :number => 5, :starts_at => '16:45', :ends_at => '18:20'
  organization.lesson_times.create :day => day, :number => 6, :starts_at => '18:30', :ends_at => '20:05'
  organization.lesson_times.create :day => day, :number => 7, :starts_at => '20:15', :ends_at => '21:50'
end

gk = organization.buildings.find_or_initialize_by_title('Главный корпус') do |b|
  b.address = '634050, г. Томск, пр. Ленина, 40'
  b.save!
end

fet = organization.buildings.find_or_initialize_by_title('Корпус ФЭТ') do |b|
  b.address = '634034, Томск, Вершинина, 74'
  b.save!
end

%w[111 222 333 444 555].each do |number|
  gk.classrooms.find_or_initialize_by_number(number).save!
  fet.classrooms.find_or_initialize_by_number(number).save!
end

['Нухимович Глеб Егорович',
 'Чуканов Александр Викторович',
 'Богатков Всеслав Андреевич',
 'Окуловa Вероника Яковлевна',
 'Тюфякинa Варвара Юрьевна',
 'Акимихинa Прасковья Львовна'].each do |fullname|
  surname, name, patronymic = fullname.split(' ')
  organization.lecturers.find_or_initialize_by_surname_and_name_and_patronymic(surname, name, patronymic).save!
end

timetable = organization.timetables.find_or_initialize_by_title('Расписание на осенний семестр') do |t|
  t.starts_on = Date.new(Date.today.year, 9, 1)
  t.ends_on = Date.new(Date.today.year, 12, 31)
  t.parity = true
  t.first_week_parity = 1
  t.save!
end

titles = ['Математический анализ', 'Сопротивление материалов', 'Начертательная геометрия', 'Занимательная микрохирургия глаза в домашних условиях (пока папа спит)']
titles.each do |title|
  organization.disciplines.create! :title => title
end
