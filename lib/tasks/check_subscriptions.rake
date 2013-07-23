desc 'Daily check for subscriptions state'
task :check_subscriptions => :environment do
  Organization.find_each do |organization|
    i = 0
    while organization.available_group_count < 0
      organization.timetables.with_status(:published)[i].unpublish
      i += 1
    end
  end
end
