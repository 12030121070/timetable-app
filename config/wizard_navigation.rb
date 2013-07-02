SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :workplace, 'Workplace', workplace_root_path
    if current_user.organizations.empty?
      primary.item :organizations, 'Create organizations', new_workplace_organization_path
    end
    primary.item :organization, @organization.title, workplace_organization_path(@organization) do |org|
      org.item :classrooms, 'Create classrooms', new_workplace_organization_building_path(@organization)
      org.item :lecturer, 'Create lecturer', new_workplace_organization_lecturer_path(@organization)
      org.item :membership, 'Create membership', workplace_organization_memberships_path(@organization)
      org.item :timetables, 'Create timetables', '#'
    end if @organization
  end
end
