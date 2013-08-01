frame = {
  container_style: {
    'background': () ->
      $('body').css('background')

    'border-left': () ->
      '1px solid #888'

    'display': () ->
      'block'

    'height': () ->
      '100%'

    'position': () ->
      'absolute'

    'right': () ->
      '-600px'

    'top': () ->
      '0'

    'width': () ->
      '600px'

    'z-index': () ->
      '3'

    to_s: () ->
      str = ""
      for propertyName of this
        str += propertyName+': '+this[propertyName]()+'; ' unless propertyName == 'to_s'
      str
  }

  container: () ->
    frame_container = $('#frame_container')
    unless frame_container.length
      frame_container = $('<div id="frame_container" style="'+this.container_style.to_s()+'" />').appendTo('body .main_wrapper')

    frame_container

  content: (html) ->
    this.container().html(html)

  data_presentation: (html) ->
    this.parent.replaceWith($(html).hide().fadeIn(500))

  overlay: () ->
    overlay_block = $('#overlay')

    unless overlay_block.length
      overlay_block = $('<div id="overlay" style="background: #222; opacity: 0.6; top: 0; bottom: 0; left: 0; right: 0; position: absolute;"/>').appendTo('body .main_wrapper')
      this.set_callbacks()

    overlay_block

  set_callbacks: () ->
    obj_this = this
    obj_this.container().on 'click', (evt) ->
      if $(evt.target).hasClass('cancel')
        obj_this.slide_right()
        false

    obj_this.container().on 'ajax:success', (evt, response) ->
      if $(response).find('.error').length
        obj_this.content(response)
      else
        obj_this.slide_right()
        obj_this.data_presentation(response)

  show_overlay: () ->
    $('.workplace_wrapper').css('-webkit-filter',  'blur(3px)')
    this.overlay().fadeIn()

  hide_overlay: () ->
    this.overlay().fadeOut()
    $('.workplace_wrapper').css('-webkit-filter',  'none')

  parent: {}

  slide_left: () ->
    this.show_overlay()
    this.container().animate(
      right: 0
    )

  slide_right: () ->
    this.hide_overlay()
    right = this.container_style.right()
    this.container().animate(
      right: right
    )
    this.content('')
}

@init_frame_handler = () ->
  $('body').on 'ajax:success', (evt, response) ->
    if $(evt.target).hasClass('in_frame')
      frame.parent = $(evt.target).closest('.data_presentation')
      frame.content(response)
      frame.slide_left()
