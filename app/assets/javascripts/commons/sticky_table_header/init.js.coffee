@init_sticky_table_handler = () ->
  table = $('.week_timetable:not(.handler_added)').addClass('handler_added')
  return unless table.length
  wrapper = table.parent()
  header = $('thead', table)
  margin = $.makeArray(table.prevAll('div, form').map (index, item) -> $(item).outerHeight(true)).reduce (a,b) => a+b
  width  = table.width()

  wrapper.on 'scroll', ->
    if wrapper.scrollTop() >= margin
      header.addClass('sticky_header').css({ 'margin-top': -margin })
    else
      header.removeClass('sticky_header').css({ 'margin-top': 0 })

  wrapper.trigger('scroll')

$ ->
  init_sticky_table_handler()