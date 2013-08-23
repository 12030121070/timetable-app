@init_timepicker = () ->
  time_pickers = $('.timepicker:not(.charged)')
  time_pickers.each (index, item) ->
    time_picker = $(item).addClass('charged')
    time_picker.timepicker
      step: 5
      timeFormat: 'H:i'
      forceRoundTime: true
      minTime: '06:00'
      maxTime: '23:55'
