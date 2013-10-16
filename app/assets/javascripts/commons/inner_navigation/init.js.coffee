@init_inner_navigation = () ->
  inner_navigations = $('.inner_navigation:not(.charged)')
  inner_navigations.each (index, item) ->
    $this = $(item).addClass('charged')
    list = $('.collection_wrapper', $this)
    current = $('.current_week', $this)
    current.add(list).hover (->
      list.show()
      current.addClass('active')
      width = $(document).width()
      $('body').css('overflow', 'hidden').css('width', width)
    ), (->
      list.hide()
      current.removeClass('active')
      $('body').css('overflow', 'auto').css('width', '100%')
    )

$ ->
  init_inner_navigation()
