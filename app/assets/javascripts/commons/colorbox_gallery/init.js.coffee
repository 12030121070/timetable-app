@init_gallery = ->
  $('.js-gallery').colorbox
      rel: 'page_images'
      close: 'закрыть'
      current: '{current} из {total}'
      maxHeight: '90%'
      maxWidth: '90%'
      next: 'следующая'
      opacity: '0.5'
      photo: true
      previous: 'предыдущая'
      returnFocus: false
      title: ->
        $(this).attr('title') || $('img', this).attr('alt') || '&nbsp;'
