get_state = () ->
  window.localStorage.getItem('important_wrapper')

set_state = (state) ->
  $('.important_wrapper').toggleClass('opened closed')
  window.localStorage.setItem('important_wrapper', state)

$ ->
  wrapper = $('.important_wrapper')
  close_link = $('.close_link', wrapper)
  open_link = $('h5', wrapper)
  inner_wrapper = $('.inner_wrapper', wrapper)

  if get_state() == 'opened'
    wrapper.addClass('opened').removeClass('closed')
    inner_wrapper.show()
  else
    wrapper.addClass('closed').removeClass('opened')
    inner_wrapper.hide()

  close_link.add(open_link).on 'click', ->
    link = $(this)
    if link.hasClass('open_link') && wrapper.hasClass('closed')
      set_state('opened')
      inner_wrapper.slideDown()

    if link.hasClass('close_link') && wrapper.hasClass('opened')
      set_state('closed')
      inner_wrapper.slideUp()
    false
