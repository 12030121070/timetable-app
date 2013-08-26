frame_handler = (parent, response, options = {}) ->
  _ = {}
  parent.addClass('not_active')
  parent_width = parent.width()
  container_width = Math.round(parent_width*0.90)
  container_styles = {
    'background': () ->
      $('.main_wrapper').css('background')
    'bottom': () ->
      '0'
    'border-left': () ->
      '1px solid #888'
    'display': () ->
      'block'
    'position': () ->
      'absolute'
    'right': () ->
      '-'+container_width+'px'
    'top': () ->
      '0'
    'width': () ->
      container_width+'px'
    'z-index': () ->
      parent_zindex = parseInt(parent.css('z-index'))
      if isNaN(parent_zindex)
        3
      else
        parent_zindex + 2

    to_s: () ->
      str = ""
      for propertyName of this
        str += propertyName+': '+this[propertyName]()+'; ' unless propertyName == 'to_s'
      str
  }
  create_container = () ->
    $('<div class="frame_container" style="'+container_styles.to_s()+'"><a href="#" class="close_link">Закрыть</a><div class="inner_wrapper"></div></div>').appendTo(parent)

  sort = (ul) ->
    arr = ul.children('li').get()
    arr.sort (a,b) ->
      a_value = $(a).text()
      b_value = $(b).text()

      return a_value.localeCompare(b_value)
    new_list = []

    arr.map (item, index) ->
      new_list.push(item)

    ul.html(new_list)

  overlay = () ->
    overlay_block = $('.overlay', parent)
    unless overlay_block.length
      overlay_block = $('<div class="overlay" style="background: #222; opacity: 0.6; top: 0; bottom: 0; left: 0; right: 0; position: absolute; z-index: 2"/>').appendTo(parent)
    overlay_block

  set_callbacks = () ->
    init_date_picker()
    init_scrollable()
    init_search()
    init_checked()
    init_autcomplete()
    init_radio_buttons()
    init_timepicker()
    init_lesson_times()

    $(window).on 'beforeunload', ->
      return 'Не сохраненные данные будет потеряны!' if parent.hasClass('not_active')

    $(document).keyup (e) ->
      if e.keyCode == 27
        _.container_hide() unless _.container.hasClass('not_active')

    _.container.children('.close_link').on 'click', ->
      _.container_hide()
      false

    _.container.on 'click', (evt) ->
      if $(evt.target).hasClass('cancel')
        _.container_hide()
        false

    _.container.on 'ajax:success', (evt, response) ->
      target = $(evt.target)
      unless target.hasClass('in_frame') || _.container.hasClass('not_active')
        if $(response).find('.error').length || target.hasClass('in_same_frame')
          _.content(response)
          init_scrollable()
          init_search()
          init_checked()
          init_autcomplete()
          init_radio_buttons()
          init_timepicker()
          init_lesson_times()
        else
          _.container_hide()
          if options.kind == 'new_record'
            options.target.append($(response).hide().fadeIn(700))
          if options.kind == 'update_record'
            options.target.replaceWith($(response).hide().fadeIn(700))
          options.list.trigger('changed')
          sort(options.list)

  off_callbacks = () ->
    $(document).off('keyup') unless $('.not_active').length

  _.container = create_container()
  _.content = (html) ->
    _.container.children('.inner_wrapper').html(html)
  _.container_show = () ->
    _.overlay_show()
    set_callbacks()
    _.container.animate
      right: 0
  _.container_hide = () ->
    _.container.animate
      right: container_styles['right']()
    _.overlay_hide()
  _.overlay_show = () ->
    overlay().fadeIn()
  _.overlay_hide = () ->
    overlay().fadeOut ->
      parent.removeClass('not_active')
      _.destroy()
      overlay().remove()
  _.destroy = () ->
    off_callbacks()
    _.container.remove()

  # run
  _.content(response)
  _.container_show()

  return _

$(window).load ->
  $('body').on('ajax:before', (evt) ->
    link = $(evt.target)
    return false if link.hasClass('busy')
    link.addClass('busy')
  ).on('ajax:success', (evt, response) ->
    link = $(evt.target)
    if link.hasClass('in_frame')
      parent = $(link.data('parent'))
      frame_handler(parent, response, {
                                        kind: link.data('kind'),
                                        target: $(link.data('target')),
                                        list: $(link.data('list'))
                                      })
    if link.hasClass('self_ajaxed')
      parent = $(link.data('target'))
      parent.replaceWith(response)
    link.removeClass('busy')
  )
