@init_radio_buttons = () ->
  radio_buttons = $('.radio_buttons:not(.charged)')
  radio_buttons.each (index, item) ->
    radio_button = $(item).addClass('charged')
    target_input = $(radio_button.data('target'))

    $('li', radio_button).on 'click', (evt) ->
      li = $(evt.target).addClass('checked')
      li.siblings().removeClass('checked')
      target_input.val(li.data('value'))
