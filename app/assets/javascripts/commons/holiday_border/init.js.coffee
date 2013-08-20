$ ->
  holidays = $('.holiday')
  holidays.each (index, item) ->
    holiday_wrapper = $(item)
    hw_class = holiday_wrapper.attr('id')

    blt = $('.holiday_blt.'+hw_class)
    brb = $('.holiday_brb.'+hw_class)
    week_timetable = $('.week_timetable')

    lt = blt.position()
    rb = brb.position()
    wt = week_timetable.position()

    holiday_wrapper.css({
      'background': '#fff'
      'opacity':    '0.8'
      'z-index':    '5'
      'position':   'relative'
      'left':       Math.abs(wt.left - lt.left)
      'top':        -Math.abs(week_timetable.outerHeight(true) - lt.top + wt.top)
      'width':      Math.abs(rb.left + brb.outerWidth(true) - wt.left - Math.abs(wt.left - lt.left) - 10)
      'height':     Math.abs(lt.top-rb.top-brb.outerHeight(true)) - 10
      'border':     '5px solid #ff4500'
    })
