SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :workplace, 'Workplace', workplace_root_path
    primary.item :organizations, 'Create organizations', new_workplace_organization_path
    primary.item :classrooms, 'Create classrooms', '#'
    primary.item :lecturer, 'Create lecturer', '#'
    primary.item :membership, 'Create membership', '#'
    primary.item :timetables, 'Create timetables', '#'
  end
end
