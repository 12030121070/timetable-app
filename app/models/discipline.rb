# encoding: utf-8

class Discipline < ActiveRecord::Base
  attr_accessible :abbr, :title, :organization

  belongs_to :organization

  before_create :update_abbr

  validates_presence_of :title
  validates_uniqueness_of :title, scope: :organization_id

private
  def update_abbr
    self.abbr = generate_abbr
  end

  def generate_abbr
    ignored  = %w[при из в и у над без до к на по о от при с]
    vocals = %w[а е ё и о у ы э ю я]
    words = (title.gsub(/\(.+\)|\/.+\Z|\*|\\.+\Z|:.+\Z|\.|\d+|-/, ' ').squish.split(' ') - ignored)

    if words.one?
      word = words.first
      if word.size > 6
        short_word = []
        word.split('').each_with_index do |w, index|
          if index <= 5
            short_word << w
          elsif index > 5 && vocals.include?(short_word.last)
            short_word << w
          else
            return short_word.join
          end
        end
        short_word.join
      else
        word
      end
    else
      words.map{ |w| w.size > 3 ? w.first.mb_chars.upcase : w }.join
    end
  end
end
