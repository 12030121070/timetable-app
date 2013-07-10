require 'importers/holiday_import'
desc 'Import holidays'
task :sync_holidays, [:file] => :environment do |t, args|
  HolidayImport.new(args[:file]).import
end
