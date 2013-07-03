require 'csv'

class CsvImport < Struct.new(:file, :imported_object)
  def import
    import_lecturers if imported_object.is_a?(Lecturer)
  end

private
  def prepare_hash
    csv_data = CSV.read(file)
    headers = csv_data.shift.map {|i| i.strip.to_sym }
    string_data = csv_data.map {|row| row.map {|cell| cell.to_s } }
    string_data.map {|row| Hash[*headers.zip(row).flatten] }
  end

  def import_lecturers
    prepare_hash.each do |item|
      imported_object.dup.update_attributes(item)
    end
  end
end
