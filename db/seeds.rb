# encoding: utf-8

user = User.find_or_initialize_by_email('demo@demo.de') do |u|
  u.password = 'demodemo'
  u.save!
end

organization = user.organization.tap do |o|
  o.title = 'Томский Государственный Университет Систем Управления и Радиоэлектроники'
  o.email = 'mail@tusur.ru'
  o.phone = '(3822) 51-05-30'
  o.site = 'http://tusur.ru'
  o.subdomain = 'tusur'
  o.save!
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

unless timetable = organization.timetables.find_by_title('Расписание на осенний семестр')
  timetable = organization.timetables.build(:title => 'Расписание на осенний семестр') do |t|
    t.starts_on = Date.new(Date.today.year, 9, 1)
    t.ends_on = Date.new(Date.today.year, 12, 31)
    t.save!
  end
end

titles = ['Математический анализ', 'Сопротивление материалов', 'Начертательная геометрия', 'Занимательная микрохирургия глаза в домашних условиях (пока папа спит)']
titles.each do |title|
  organization.disciplines.create! :title => title
end
