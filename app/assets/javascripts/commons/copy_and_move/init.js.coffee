@init_copy_and_move = () ->
  copy_check = $('.copy_check').parent().css('cursor', 'pointer')
  copy_check.on 'click', ->
    $this = $(this)
    checkbox = $this.find('input')
    if checkbox.attr('checked') == 'checked'
      checkbox.removeAttr('checked')
      $this.removeClass('active')
    else
      checkbox.prop('checked', 'checked').attr('checked', 'checked')
      $this.addClass('active')

  move_radio = $('.move_radio').parent().css('cursor', 'pointer')
  move_radio.on 'click', ->
    $this = $(this)
    radio = $this.find('input')
    unless radio.attr('checked') == 'checked'
      move_radio.removeClass('active')
      $this.addClass('active')
      radio.prop('checked', 'checked')
