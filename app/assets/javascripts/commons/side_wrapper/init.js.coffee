get_state = () ->
  window.localStorage.getItem('side_wrapper')

set_state = (state) ->
  window.localStorage.setItem('side_wrapper', state)

$ ->
  side_wrapper = $('.side_wrapper')
  handle = $('.handle', side_wrapper)
  b_s = $('b', side_wrapper)

  if get_state() == 'opened'
    handle.html('&lang;')
    b_s.show()
    side_wrapper.removeClass('closed').addClass('opened')
  else if get_state() == 'closed'
    handle.html('&rang;')
    b_s.hide()
    side_wrapper.removeClass('opened').addClass('closed')
  else
    handle.html('&rang;')
    b_s.hide()
    side_wrapper.removeClass('opened').addClass('closed')

  handle.on 'click', ->
    if side_wrapper.hasClass('opened')
      handle.html('&rang;')
      b_s.slideUp()
      side_wrapper.animate({ width: '52px' })
      set_state('closed')
    if side_wrapper.hasClass('closed')
      handle.html('&lang;')
      side_wrapper.animate({ width: '245px' })
      b_s.slideDown()
      set_state('opened')
    side_wrapper.toggleClass('opened closed')
