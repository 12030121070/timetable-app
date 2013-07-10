# encoding: utf-8

class HolidayImport

  def initialize(path)
    @path = path

    import
  end

  def import
    prepare_hash.each do |k,v|
      Holiday.create(date: k) if v == 'holiday'
    end
  end
  
  private
  
  def prepare_hash
    data = JSON.parse(File.read(@path))
  end
end
