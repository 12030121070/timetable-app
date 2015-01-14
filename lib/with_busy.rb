module WithBusy
  extend ActiveSupport::Concern

  module ClassMethods
    def with_busy(options)
      method, message = options[:method], options[:message]

      define_method "#{method}_with_busy" do |day, lesson_time, lesson|
        if self.is_a?(Group)
          if busy_at?(day, lesson_time, lesson)
            if has_lessons_with_subgroup_at?(day, lesson_time)
              "#{send(method)} (уже есть занятие в подгруппе #{lessons_with_subgroup_at(day, lesson_time).first.subgroup_text})"
            else
              "#{send(method)} (#{message})"
            end
          else
            send(method)
          end
        else
          send(method).tap { |s| s << " (#{message})" if busy_at?(day, lesson_time, lesson) }
        end
      end

      define_method "autocomplete_#{method}_with_busy" do |day, lesson_time, lesson|
        if self.is_a?(Group)
          if has_lessons_at?(day, lesson_time)
            if has_lessons_with_subgroup_at?(day, lesson_time)
              "#{send(method)} (уже есть занятие в подгруппе #{lessons_with_subgroup_at(day, lesson_time).first.subgroup_text})"
            else
              "#{send(method)} (#{message})"
            end
          else
            send(method)
          end
        else
          send(method).tap { |s| s << " (#{message})" if has_lessons_at?(day, lesson_time) }
        end
      end
    end
  end

  private

  def lessons_at(day, lesson_time)
    lessons.joins(:day).where('days.date = ?', day.date)
      .joins(:lesson_time).where('lesson_times.day = ? AND lesson_times.number = ?', day.cwday, lesson_time.number)
  end

  def lessons_with_subgroup_at(day, lesson_time)
    lessons_at(day, lesson_time).where('lessons.subgroup != ?', :whole)
  end

  def has_lessons_with_subgroup_at?(day, lesson_time)
    lessons_with_subgroup_at(day, lesson_time).any?
  end

  def has_lessons_at?(day, lesson_time)
    lessons_at(day, lesson_time).any?
  end

  def busy_at?(day, lesson_time, lesson)
    has_lessons_at?(day, lesson_time) && !self.lessons.include?(lesson)
  end
end
