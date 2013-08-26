show_or_hide = (checkbox) ->
  if checkbox.prop('checked')
    checkbox.closest('div').next('.radio_buttons').slideDown()
  else
    checkbox.closest('div').next('.radio_buttons').slideUp()

@init_checked = () ->
  inputs = $('input.boolean:not(.charged)')
  inputs.each (index, item) ->
    $item = $(item).addClass('charged')
    show_or_hide($item)

    $item.on 'change', ->
      show_or_hide($(this))
