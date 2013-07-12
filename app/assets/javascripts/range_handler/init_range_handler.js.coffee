@init_range_handler = () ->
  range = $('input.range')
  return unless range.length

  range.each (index, item) ->
    $(item).after('<span class="counter"/>')

  range.on 'change', ->
    $this = $(this)
    $this.next('.counter').html($this.val())

  range.each (index, item) ->
    $this = $(item)
    $this.val($this.data('init')).trigger('change')
