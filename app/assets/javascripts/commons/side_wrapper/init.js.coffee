get_state = () ->
  window.localStorage.getItem('side_wrapper')

set_state = (state) ->
  window.localStorage.setItem('side_wrapper', state)

$ ->
  side_wrapper = $('.side_wrapper')
  handle = $('.handle', side_wrapper)
  b_s = $('b', side_wrapper)
  footer = $('.footer', side_wrapper)

  if get_state() == 'opened'
    handle.html('&#x2039;')
    b_s.show()
    footer.css({'margin-bottom': '0px', width: '245px'})
    side_wrapper.removeClass('closed').addClass('opened')
  else
    handle.html('&#x203A;')
    b_s.each (index, item) ->
      $item = $(item)
      $item.data('height', $item.css('height'))
      $item.hide()
    footer.css({'margin-bottom': '-80px', width: '52px'})
    side_wrapper.removeClass('opened').addClass('closed')

  handle.on 'click', ->
    if side_wrapper.hasClass('opened')
      handle.html('&#x203A;')
      side_wrapper.animate({ width: '52px' })
      b_s.each (index, item) ->
        $item = $(item)
        $item.data('height', $item.css('height'))
        $item.animate({ height: '32px' })
      footer.animate({'margin-bottom': '-80px', width: '52px'})
      set_state('closed')
    if side_wrapper.hasClass('closed')
      handle.html('&#x2039;')
      side_wrapper.animate({ width: '245px' })
      b_s.each (index, item) ->
        $item = $(item)
        $item.show ->
          $item.animate({ height: $item.data().height })
      footer.animate({'margin-bottom': '0px', width: '245px'})
      set_state('opened')
    side_wrapper.toggleClass('opened closed')
