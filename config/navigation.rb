# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |side_nav|
    if @organization.try(:persisted?)
      side_nav.item :timetables,  '<span></span><b>Расписания</b>', workplace_timetables_path,    :highlights_on => -> { controller_name == 'timetables' }
      side_nav.item :members,     '<span></span><b>Менеджеры</b>',  workplace_memberships_path,   :highlights_on => -> { controller_name == 'memberships' }
      side_nav.item :lecturers,   '<span></span><b>Лекторы</b>',    workplace_lecturers_path,     :highlights_on => -> { controller_name == 'lecturers' }
      side_nav.item :buildings,   '<span></span><b>Корпуса</b>',    workplace_buildings_path,     :highlights_on => -> { controller_name == 'buildings' }
      side_nav.item :disciplines, '<span></span><b>Дисциплины</b>', workplace_disciplines_path,   :highlights_on => -> { controller_name == 'disciplines' }
      side_nav.item :separator,   '', "#"
      side_nav.item :lecturers_loading, '<span></span><b>Загрузка лекторов</b>', '#'
      side_nav.item :buildings_loading, '<span></span><b>Загрузка аудиторий</b>', '#'
    end
  end
end
