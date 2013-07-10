class Lesson < ActiveRecord::Base
  extend Enumerize

  attr_accessible :kind, :lesson_time_id, :discipline_id, :subgroup,
    :classroom_lessons_attributes, :lecturer_lessons_attributes, :group_lessons_attributes

  belongs_to :day
  belongs_to :discipline
  belongs_to :lesson_time

  has_many :classroom_lessons, :dependent => :destroy
  has_many :classrooms, :through => :classroom_lessons

  has_many :group_lessons, :dependent => :destroy
  has_many :groups, :through => :group_lessons

  has_many :lecturer_lessons, :dependent => :destroy
  has_many :lecturers, :through => :lecturer_lessons

  accepts_nested_attributes_for :classroom_lessons, :allow_destroy => true
  accepts_nested_attributes_for :group_lessons, :allow_destroy => true
  accepts_nested_attributes_for :lecturer_lessons, :allow_destroy => true

  validates_presence_of :discipline, :kind, :subgroup

  enumerize :kind,
    in: [:lecture, :practice, :laboratory, :research, :design, :exam, :test],
    predicates: true

  enumerize :subgroup,
    :in => [:whole, :a, :b],
    :default => :whole,
    :predicates => { :prefix => true }

  delegate :week, :to => :day

  # TODO: need optimization
  def available_subgroup_options
    group_ids = group_lessons.map(&:group_id)
    existing_subgroups = self.class.where(:day_id => day.id, :lesson_time_id => lesson_time.id).joins(:groups).where('groups.id' => group_ids).pluck(:subgroup)

    return self.class.subgroup.options if existing_subgroups.empty? || existing_subgroups == ['whole']

    if new_record?
      subgroups = self.class.subgroup.values - ['whole'] - existing_subgroups
    else
      subgroups = existing_subgroups.many? ? [subgroup] : self.class.subgroup.values
    end

    return self.class.subgroup.options.select { |title, value| subgroups.include?(value) }
  end

  def available_cells_for_copy_and_move
    cells = week.cells
    (lecturers + groups + classrooms).flat_map(&:lessons).each do |lesson|
      cells[lesson.day] -= [lesson.lesson_time]
    end

    cells
  end

  def copy_to(day, lesson_time = self.lesson_time)
    new_lesson = self.class.new do |new_lesson|
      new_lesson.day         = day
      new_lesson.discipline  = discipline
      new_lesson.kind        = kind
      new_lesson.lesson_time = lesson_time
      new_lesson.subgroup    = subgroup

      new_lesson.save!
    end

    new_lesson.groups     << groups
    new_lesson.lecturers  << lecturers
    new_lesson.classrooms << classrooms
  end

  def move_to(day, lesson_time)
    self.day = day
    self.lesson_time = lesson_time
    self.save!
  end
end
