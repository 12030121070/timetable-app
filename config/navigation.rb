# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |side_nav|
    if @organization.try(:persisted?)
      side_nav.item :timetables,  '<span title="Расписание"></span><b>Расписания</b>', workplace_timetables_path,    :highlights_on => -> { ['timetables', 'weeks'].include?(controller_name) }
      side_nav.item :members,     '<span title="Менеджеры"></span><b>Менеджеры</b>',  workplace_memberships_path,   :highlights_on => -> { controller_name == 'memberships' }
      side_nav.item :lecturers,   '<span title="Лекторы"></span><b>Лекторы</b>',    workplace_lecturers_path,     :highlights_on => -> { controller_name == 'lecturers' }
      side_nav.item :buildings,   '<span title="Корпуса и аудитории"></span><b>Корпуса и аудитории</b>',    workplace_buildings_path,     :highlights_on => -> { controller_name == 'buildings' }
      side_nav.item :disciplines, '<span title="Дисциплины"></span><b>Дисциплины</b>', workplace_disciplines_path,   :highlights_on => -> { controller_name == 'disciplines' }
    end
  end
end
