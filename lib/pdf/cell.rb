class Pdf::Cell
  attr_accessor :content, :colspan, :rowspan, :visibiliity

  def initialize(content, colspan = 1, rowspan = 1)
    @content = content
    @colspan = colspan
    @rowspan = rowspan
    @visibiliity = true
  end

  def to_h
    { :content => content, :colspan => colspan, :rowspan => rowspan }
  end

  def visibiliity?
    visibiliity
  end
end
