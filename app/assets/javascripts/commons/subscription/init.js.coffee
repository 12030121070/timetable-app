set_sum = (tariff) ->
  month_input = $('input.months_counter')
  group_input = $('input.groups_counter')
  month_count = parseInt(month_input.val()) || 0
  group_count = parseInt(group_input.val()) || 0
  sum = month_count * group_count
  $('.sum .without_discount').html(accounting.formatMoney(sum*tariff.cost, { symbol: 'руб.', format: '%v %s', thousand: ' ', precision: 0 }))

  if group_count >= tariff.min_group && group_count < tariff.half_groups
    if month_count >= tariff.min_month && month_count < tariff.half_months
      month_input.data('discount', 0)
      group_input.data('discount', 0)
      sum *= tariff.first_plan
    else if month_count >= tariff.half_months && month_count < tariff.max_month
      month_input.data('discount', tariff.discount_half_year)
      group_input.data('discount', 0)
      sum *= tariff.second_plan
    else if month_count >= tariff.max_month
      month_input.data('discount', tariff.discount_year)
      group_input.data('discount', 0)
      sum *= tariff.third_plan
  else if group_count >= tariff.half_groups && group_count < tariff.max_group
    if month_count >= tariff.min_month && month_count < tariff.half_months
      month_input.data('discount', 0)
      group_input.data('discount', tariff.discount_medium)
      sum *= tariff.fourth_plan
    else if month_count >= tariff.half_months && month_count < tariff.max_month
      month_input.data('discount', tariff.discount_half_year)
      group_input.data('discount', tariff.discount_medium)
      sum *= tariff.fith_plan
    else if month_count >= tariff.max_month
      month_input.data('discount', tariff.discount_year)
      group_input.data('discount', tariff.discount_medium)
      sum *= tariff.sixth_plan
  else if group_count >= tariff.max_group
    if month_count >= tariff.min_month && month_count < tariff.half_months
      month_input.data('discount', 0)
      group_input.data('discount', tariff.discount_large)
      sum *= tariff.seventh_plan
    else if month_count >= tariff.half_months && month_count < tariff.max_month
      month_input.data('discount', tariff.discount_half_year)
      group_input.data('discount', tariff.discount_large)
      sum *= tariff.eighth_plan
    else if month_count >= tariff.max_month
      month_input.data('discount', tariff.discount_year)
      group_input.data('discount', tariff.discount_large)
      sum *= tariff.nineth_plan

  $('.counter.months_counter span.discount').html('(скидка ' + (month_input.data('discount') || 0) + '%)')
  $('.counter.groups_counter span.discount').html('(скидка ' + (group_input.data('discount') || 0) + '%)')
  $('.sum .discount').html(month_input.data('discount')+group_input.data('discount'))
  $('.sum .value').html(accounting.formatMoney(sum, { symbol: 'руб.', format: '%v %s', thousand: ' ', precision: 0 }))

@init_subscription = () ->
  form = $('.new_subscription')
  tariff = form.parent().data('tariff')
  inputs =$('input.range', form)
  range = $('div.range')

  inputs.on 'change', ->
    target_class = if $(this).hasClass('months_counter') then 'months_counter' else 'groups_counter'
    $('.counter.'+target_class+' span.value', form).html($(this).val())
    set_sum(tariff)

  range.each (index, item) ->
    slider = $(item)
    slider.slider
      min: slider.data('min')
      max: slider.data('max')
      value: slider.data('init')
      step: slider.data('step')
      create: (event, ui) ->
        $('input.'+$(event.target, form).attr('id'), form).val($(event.target).slider('value')).trigger('change')
      slide: (event, ui) ->
        $('input.'+$(event.target, form).attr('id'), form).val(ui.value).trigger('change')

$ ->
  init_subscription()
