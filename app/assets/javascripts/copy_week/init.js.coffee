@init_copy_week = () ->
  copy_link = $('.copy_link')

  return unless copy_link.length

  form = $('form.copy_week')

  copy_link.on 'click', ->
    link = $(this)
    switch link.attr('id')
      when 'copy_all'
        form.find(':checkbox').prop('checked', true)
      when 'copy_even'
        form.find('.even_checkbox:checkbox').prop('checked', true)
      when 'copy_odd'
        form.find('.odd_checkbox:checkbox').prop('checked', true)
      when 'uncheck'
        form.find(':checkbox').prop('checked', false)
    false
