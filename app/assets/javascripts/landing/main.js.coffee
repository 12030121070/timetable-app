auth_handler = () ->
  form_wrapper = $('.auth_form')
  form = $('form', form_wrapper)
  $('.actions', form_wrapper).on 'click', (evt) ->
    target = $(evt.target)
    return unless target.is('a')

    form.attr('action', target.attr('href'))
    form.submit()

    false

go_top = () ->
  $('.go_top a').on 'click', ->
    $('body').animate({ scrollTop: 0 })
    false

carousel_handler = () ->
  carousel = $('.carousel')
  list = $('ul', carousel)
  controls = $('.controls', carousel)
  intId = setInterval(->
    $('.next', controls).click()
  , 5000)

  controls.on 'click', (evt) ->
    clearInterval(intId)
    target = $(evt.target)
    current_margin = parseInt(list.css('margin-left'))
    if target.hasClass('prev')
      last = $('li:last', list).css({opacity: 0})
      list.prepend(last.animate({opacity: 1}, 700))
    if target.hasClass('next')
      second = $('li:nth-child(2)', list).css({opacity: 0})
      list.append($('li:first', list))
      second.animate({opacity: 1}, 700)
    intId = setInterval(->
      $('.next', controls).click()
    , 5000)
    false

$ ->
  auth_handler()
  carousel_handler()
  go_top()
  init_subscription()
