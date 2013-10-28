auth_handler = () ->
  form_wrapper = $('.auth_form')
  form = $('form', form_wrapper)
  $('.actions', form_wrapper).on 'click', (evt) ->
    target = $(evt.target)
    return unless target.is('a')

    form.attr('action', target.attr('href'))
    form.submit()

    false

go_top = () ->
  $('.go_top a').on 'click', ->
    $('body').animate({ scrollTop: 0 })
    false

carousel_handler = () ->
  carousel = $('.carousel')
  list = $('ul', carousel)
  controls = $('.controls', carousel)
  intId = setInterval(->
    $('.next', controls).click()
  , 5000)

  controls.on 'click', (evt) ->
    clearInterval(intId)
    target = $(evt.target)
    current_margin = parseInt(list.css('margin-left'))
    if target.hasClass('prev')
      last = $('li:last', list).css({opacity: 0})
      list.prepend(last.animate({opacity: 1}, 700))
    if target.hasClass('next')
      second = $('li:nth-child(2)', list).css({opacity: 0})
      list.append($('li:first', list))
      second.animate({opacity: 1}, 700)
    intId = setInterval(->
      $('.next', controls).click()
    , 5000)
    false

tariff_handler = () ->
  tariff_wrapper = $('.tariff_wrapper')
  return unless tariff_wrapper.length
  sliders = $('.slider', tariff_wrapper)
  tariff = tariff_wrapper.data('tariff')

  calculate = () ->
    month = $(sliders).filter('.month')
    group = $(sliders).filter('.group')
    month_count = month.data('value') || month.slider('value')
    group_count = group.data('value') || group.slider('value')
    sum = month_count * group_count
    $('.total .sum').html(accounting.formatMoney(sum*tariff.cost, { symbol: 'рублей', format: '%v %s', thousand: ' ', precision: 0 }))
    month.data('discount', 0)
    group.data('discount', 0)

    if group_count >= tariff.min_group && group_count < tariff.half_groups
      if month_count >= tariff.min_month && month_count < tariff.half_months
        month.data('discount', 0)
        group.data('discount', 0)
        sum *= tariff.first_plan
      else if month_count >= tariff.half_months && month_count < tariff.max_month
        month.data('discount', tariff.discount_half_year)
        group.data('discount', 0)
        sum *= tariff.second_plan
      else if month_count >= tariff.max_month
        month.data('discount', tariff.discount_year)
        group.data('discount', 0)
        sum *= tariff.third_plan
    else if group_count >= tariff.half_groups && group_count < tariff.max_group
      if month_count >= tariff.min_month && month_count < tariff.half_months
        month.data('discount', 0)
        group.data('discount', tariff.discount_medium)
        sum *= tariff.fourth_plan
      else if month_count >= tariff.half_months && month_count < tariff.max_month
        month.data('discount', tariff.discount_half_year)
        group.data('discount', tariff.discount_medium)
        sum *= tariff.fith_plan
      else if month_count >= tariff.max_month
        month.data('discount', tariff.discount_year)
        group.data('discount', tariff.discount_medium)
        sum *= tariff.sixth_plan
    else if group_count >= tariff.max_group
      if month_count >= tariff.min_month && month_count < tariff.half_months
        month.data('discount', 0)
        group.data('discount', tariff.discount_large)
        sum *= tariff.seventh_plan
      else if month_count >= tariff.half_months && month_count < tariff.max_month
        month.data('discount', tariff.discount_half_year)
        group.data('discount', tariff.discount_large)
        sum *= tariff.eighth_plan
      else if month_count >= tariff.max_month
        month.data('discount', tariff.discount_year)
        group.data('discount', tariff.discount_large)
        sum *= tariff.nineth_plan

    group_count_string = group_count+' гр.'
    group_count_string += ' <span>(скидка ' + (group.data('discount') || 0) + '%)</span>' if group.data('discount') != 0
    month_count_string = month_count+' мес.'
    month_count_string += ' <span>(скидка ' + (month.data('discount') || 0) + '%)</span>' if month.data('discount') != 0
    discount_string = ''
    discount = month.data('discount')+group.data('discount')
    discount_string += '- '+discount+'%'
    $('.counter.group').html(group_count_string)
    $('.counter.month').html(month_count_string)
    $('.total .discount').html(discount_string)

    if isNaN(sum)
      $('.total .sum_with_discount').html('бесплатно')
    else
      $('.total .sum_with_discount').html(accounting.formatMoney(sum, { symbol: 'рублей', format: '%v %s', thousand: ' ', precision: 0 }))

  sliders.each (index, item) ->
    slider = $(item)
    slider.slider
      min: slider.data('min')
      max: if slider.hasClass('group') then slider.data('max')+19 else slider.data('max')
      value: slider.data('init')
      step: slider.data('step')
      slide: (event, ui) ->
        value = ui.value
        if slider.hasClass('group')
          if ui.value < 25
            value = 'меньше '+tariff.min_group+' '
          else
            value = ui.value - 19

        slider.data('value', value)
        calculate()
  calculate()

$ ->
  auth_handler()
  carousel_handler()
  go_top()
  tariff_handler()
