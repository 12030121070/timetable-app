@init_copy_and_move = () ->
  copy_check = $('.copy_check').parent().css('cursor', 'pointer')
  copy_check.on 'click', ->
    $this = $(this)
    checkbox = $this.find('input')
    if checkbox.prop('checked')
      checkbox.prop('checked', false)
      $this.removeClass('active')
    else
      checkbox.prop('checked', true)
      $this.addClass('active')

  move_radio = $('.move_radio').parent().css('cursor', 'pointer')
  move_radio.on 'click', ->
    $this = $(this)
    radio = $this.find('input')
    unless radio.prop('checked')
      move_radio.removeClass('active')
      $this.addClass('active')
      radio.prop('checked', true)
