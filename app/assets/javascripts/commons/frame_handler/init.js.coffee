frame_handler = (parent, response) ->
  _ = {}
  parent_width = parent.width()
  container_width = Math.round(parent_width*0.90)
  container_styles = {
    'background': () ->
      $('body').css('background')
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
        1
      else
        parent_zindex + 1

    to_s: () ->
      str = ""
      for propertyName of this
        str += propertyName+': '+this[propertyName]()+'; ' unless propertyName == 'to_s'
      str
  }
  create_container = () ->
    $('<div class="frame_container" style="'+container_styles.to_s()+'"><a href="#" class="close_link">Закрыть</a><div class="inner_wrapper"></div></div>').appendTo(parent)

  overlay = () ->
    overlay_block = $('.overlay')
    unless overlay_block.length
      overlay_block = $('<div class="overlay" style="background: #222; opacity: 0.6; top: 0; bottom: 0; left: 0; right: 0; position: absolute;"/>').appendTo(parent)
    overlay_block

  set_callbacks = () ->
    $(document).off('keyup')
    $(document).keyup (e) ->
      if e.keyCode == 27
        _.container_hide()

    _.container.children('.close_link').on 'click', ->
      _.container_hide()
      false

    _.container.on 'click', (evt) ->
      if $(evt.target).hasClass('cancel')
        _.container_hide()
        false

    _.container.on 'ajax:success', (evt, response) ->
      if $(response).find('.error').length
        _.content(response)
      else
        _.container_hide()
        # update_parent

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
      _.destroy()
      overlay().remove()
  _.destroy = () ->
    _.container.remove()

  # run
  _.content(response)
  _.container_show()

  return _

$ ->
  $('body').on 'ajax:success', (evt, response) ->
    link = $(evt.target)
    if link.hasClass('in_frame')
      parent = $(link.data('parent'))
      frame_handler(parent, response)
