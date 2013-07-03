require 'csv'

class CsvImport < Struct.new(:file, :imported_object)
  def import
    import_lecturers if imported_object.is_a?(Lecturer)
    import_buildings if imported_object.is_a?(Building)
  end

private
  def prepare_hash
    csv_data = CSV.read(file)
    headers = csv_data.shift.map {|i| i.strip.to_s }
    string_data = csv_data.map {|row| row.map {|cell| cell.to_s.strip } }
    string_data.map {|row| Hash[*headers.zip(row).flatten] }
  end

  def import_lecturers
    prepare_hash.each do |item|
      imported_object.dup.update_attributes(item) unless Lecturer.where(item).any?
    end
  end

  def import_buildings
    prepare_hash.each do |item|
      classroom = item.delete('number')
      building_attributes = imported_object.dup.attributes.merge(item).except('created_at', 'updated_at')
      building = Building.where(building_attributes).first_or_create

      building.classrooms.where(:number => classroom).first_or_create
    end
  end
end
