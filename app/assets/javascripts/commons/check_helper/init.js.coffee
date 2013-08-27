@init_check_helper = () ->
  form = $('form.copy_week')
  form.on 'click', ->
    $('.check_helper a').removeClass('active')
  $('.check_helper').on 'click', (evt) ->
    $target = $(evt.target)
    if $target.is('a')
      $target.siblings('a').removeClass('active')
      $target.addClass('active') unless $target.hasClass('uncheck')

      switch $target.attr('id')
        when 'copy_all'
          form.find(':checkbox').prop('checked', true)
        when 'copy_even'
          form.find(':checkbox').prop('checked', false)
          form.find('.even_checkbox:checkbox').prop('checked', true)
        when 'copy_odd'
          form.find(':checkbox').prop('checked', false)
          form.find('.odd_checkbox:checkbox').prop('checked', true)
        when 'uncheck'
          form.find(':checkbox').prop('checked', false)

      return false
