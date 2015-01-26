show = (anchor) ->
  $('.sly_wrapper').show().not(".#{anchor.slice(1)}_wrapper").hide()

$ ->
  sidebar = $('.js-sidebar')
  init_gallery()        if $('.js-gallery').length
  init_sticky_sidebar() if sidebar.length

  if sidebar.length
    anchor = window.location.hash || '#about'
    show(anchor)

    sidebar.on 'click', (evt) ->
      $this = $(evt.target)
      if $this.is('a')
        show $this.attr('href').match(/#.+/)[0]
