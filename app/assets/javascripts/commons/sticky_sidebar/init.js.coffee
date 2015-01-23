@init_sticky_sidebar = ->
  console.log 'init'

  isScrolledTo = (elem) ->
    docViewTop = $(window).scrollTop()
    docViewBottom = docViewTop + $(window).height()
    elemTop = $(elem).offset().top
    elemBottom = elemTop + $(elem).height()
    elemTop <= docViewTop

  sidebar = $(".js-sidebar")
  offset = 130

  $(window).scroll ->
    if isScrolledTo(sidebar)
      sidebar.css "position", "fixed"
      sidebar.css "top", "0px"

    if offset > sidebar.offset().top
      sidebar.css "position", "absolute"
      sidebar.css "top", offset
    return

  return
