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
      wrapper.css('overflow', 'hidden').css('width', width)
    ), (->
      list.hide()
      current.removeClass('active')
      wrapper.css('overflow', 'auto').css('width', '100%')
    )

$ ->
  init_inner_navigation()
