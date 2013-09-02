@init_inner_navigation = () ->
  inner_navigations = $('.inner_navigation:not(.charged)')
  inner_navigations.each (index, item) ->
    $this = $(item).addClass('charged')
    list = $('.collection_wrapper', $this)
    current = $('.current_week', $this)
    current.add(list).hover (->
      list.show()
      current.addClass('active')
    ), (->
      list.hide()
      current.removeClass('active')
    )

$ ->
  init_inner_navigation()
