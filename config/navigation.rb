# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |side_nav|
    side_nav.item :timetables,  '<span></span><b>Расписания</b>', workplace_organization_timetables_path(@organization),    :highlights_on => -> { controller_name == 'timetables' }
    side_nav.item :subscribes,  '<span></span><b>Подписки</b>',   workplace_organization_subscriptions_path(@organization), :highlights_on => -> { controller_name == 'subscriptions' }
    side_nav.item :members,     '<span></span><b>Менеджеры</b>',  workplace_organization_memberships_path(@organization),   :highlights_on => -> { controller_name == 'memberships' }
    side_nav.item :lecturers,   '<span></span><b>Лекторы</b>',    workplace_organization_lecturers_path(@organization),     :highlights_on => -> { controller_name == 'lecturers' }
    side_nav.item :buildings,   '<span></span><b>Корпуса</b>',    workplace_organization_buildings_path(@organization),     :highlights_on => -> { controller_name == 'buildings' }
    side_nav.item :disciplines, '<span></span><b>Дисциплины</b>', workplace_organization_disciplines_path(@organization),   :highlights_on => -> { controller_name == 'disciplines' }
  end
end
