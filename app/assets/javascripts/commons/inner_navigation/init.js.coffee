jQuery.browser = {}
(->
  jQuery.browser.msie = false
  jQuery.browser.version = 0
  if navigator.userAgent.match(/MSIE ([0-9]+)\./)
    jQuery.browser.msie = true
    jQuery.browser.version = RegExp.$1
)()

@init_inner_navigation = () ->
  inner_navigations = $('.inner_navigation:not(.charged)')
  inner_navigations.each (index, item) ->
    $this = $(item).addClass('charged')
    list = $('.collection_wrapper', $this)
    wrapper = $($this.data('wrapper'))
    current = $('.current_week', $this)
    current.add(list).hover (->
      list.show()
      current.addClass('active')
      width = wrapper.width()
      if wrapper.is('body')
        wrapper.css('overflow', 'hidden').css({ 'width': width, 'right': $.getScrollbarWidth(), 'position': 'absolute' })
      else
        wrapper.css('overflow', 'hidden').css({ 'width': width-$.getScrollbarWidth() })
    ), (->
      list.hide()
      current.removeClass('active')
      if wrapper.is('body')
        wrapper.css('overflow', 'auto').css({ 'width': '100%', 'right': 0, 'position': 'static' })
      else
        wrapper.css('overflow', 'auto').css({ 'width': '100%' })
    )

$ ->
  init_inner_navigation()
