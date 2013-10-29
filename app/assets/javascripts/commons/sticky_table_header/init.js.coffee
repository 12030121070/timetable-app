$ ->
  table = $('.week_timetable')
  wrapper = table.parent()
  header = $('thead', table)
  margin = $.makeArray(table.prevAll('div, form').map (index, item) -> $(item).outerHeight(true)).reduce (a,b) => a+b
  width  = table.width()

  wrapper.on 'scroll', ->
    if wrapper.scrollTop() >= margin
      header.addClass('sticky_header').css({ 'margin-top': -margin })
    else
      header.removeClass('sticky_header').css({ 'margin-top': 0 })
