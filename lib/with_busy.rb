module WithBusy
  extend ActiveSupport::Concern

  module ClassMethods
    def with_busy(options)
      method, message = options[:method], options[:message]

      define_method "#{method}_with_busy" do |day, lesson_time, excluded_lesson|
        send(method).tap { |s| s << " (#{message})" if busy_at? day, lesson_time, excluded_lesson }
      end
    end
  end

  def busy_at?(day, lesson_time, excluded_lesson)
    lessons.joins(:day).where('days.date = ?', day.date)
      .joins(:lesson_time).where('lesson_times.day = ? AND lesson_times.number = ?', day.cwday, lesson_time.number).any?
  end
end
