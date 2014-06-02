class LessonTimeCreator
  attr_accessor :organization

  def initialize(organization)
    @organization = organization
  end

  def create
    days.each do |day|
      times.each_with_index do |attributes, number|
        organization.lesson_times.create! attributes.merge(:day => day, :number => number)
      end
    end
  end

  private

  def days
    1..6
  end

  def times
    [
      { :starts_at => '8:30', :ends_at => '10:00' },
      { :starts_at => '10:10', :ends_at => '11:40' },
      { :starts_at => '11:50', :ends_at => '13:20' },

      { :starts_at => '14:00', :ends_at => '15:30' },
      { :starts_at => '15:40', :ends_at => '17:10' },
      { :starts_at => '17:20', :ends_at => '18:50' },
      { :starts_at => '19:00', :ends_at => '20:00' }
    ]
  end
end
