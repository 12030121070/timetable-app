@init_checked = () ->
  inputs = $('input.boolean:not(.charged)')
  inputs.each (index, item) ->
    $item = $(item).addClass('charged')

    $item.on 'change', ->
      checkbox = $(this)
      if checkbox.prop('checked')
        checkbox.closest('div').next('.radio_buttons').slideDown()
      else
        checkbox.closest('div').next('.radio_buttons').slideUp()
