class Group < ActiveRecord::Base
  attr_accessible :title

  belongs_to :timetable

  has_many :group_lessons, :dependent => :destroy
  has_many :lessons, :through => :group_lessons, :order => 'lessons.subgroup ASC'
  has_many :weeks, :through => :timetable, :order => 'weeks.number ASC'
  has_one :organization, :through => :timetable

  validates_presence_of :title
  validates_uniqueness_of :title, :scope => :timetable_id

  delegate :status, :to => :timetable, :prefix => true
  delegate :id, :to => :organization, :prefix => true

  searchable do
    text :title
    string :title
    string :timetable_status
    integer :organization_id
  end

  def closest_week
    week = weeks.current

    if week.empty?
      past_week = weeks.past.last
      future_week = weeks.future.first

      if past_week && future_week
        if (past_week.date_on.end_of_week..Time.zone.today).count < (Time.zone.today..future_week.date_on.beginning_of_week).count
          week = past_week
        else
          week = future_week
        end
      else
        week = past_week if past_week
        week = future_week if future_week
      end
    end

    week
  end

  def table_on(week = closest_week)
    {
      :days => week.study_days,
      :rows => timetable.lesson_times.group_by(&:number).map do |lesson_time_number, lesson_times|
        lesson_times.map do |lesson_time|
          [lesson_time, lesson_time.lessons.joins(:group_lessons).where(:group_lessons => { :group_id => self.id }, :lessons => {:day_id => week.study_days.map(&:id)}) ]
        end
      end
    }
  end
end
