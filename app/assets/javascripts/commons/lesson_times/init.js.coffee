@init_lesson_times = () ->
  init_tabs()
  $(document).on 'nested:fieldAdded', (event) ->
    div_field = $(event.target)
    value = div_field.parent().data('value')
    $('input.lesson_time_day', div_field).val(value)
    init_timepicker()
