set_sum = (tariff) ->
  month_count = parseInt($('input.month_count').val())
  group_count = parseInt($('input.group_count').val())
  sum = month_count * group_count

  if month_count >= tariff.min_month && month_count < tariff.half_months && group_count >= tariff.min_group && group_count < tariff.half_groups
    sum *= tariff.first_plan
  else if month_count >= tariff.half_months && month_count < tariff.max_months && group_count >= tariff.min_group && group_count < tariff.half_groups
    sum *= tariff.second_plan
  else if month_count >= tariff.max_month && group_count >= tariff.min_group && group_count < tariff.half_groups
    sum *= tariff.third_plan
  else if month_count >= tariff.min_month && month_count < tariff.half_months && group_count >= tariff.half_groups && group_count < tariff.max_group
    sum *= tariff.fourth_plan
  else if month_count >= tariff.half_months && month_count < tariff.max_months && group_count >= tariff.half_groups && group_count < tariff.max_group
    sum *= tariff.fith_plan
  else if month_count >= tariff.max_months && group_count >= tariff.half_groups && group_count < tariff.max_group
    sum *= tariff.sixth_plan
  else if month_count >= tariff.min_month && group_count < tariff.half_months && group_count >= tariff.half_groups && group_count < tariff.max_group
    sum *= tariff.seventh_plan
  else if month_count >= tariff.half_months && group_count < tariff.max_months && group_count >= tariff.half_groups && group_count < tariff.max_group
    sum *= tariff.eighth_plan
  else if month_count >= tariff.max_month && group_count >= tariff.half_groups && group_count < tariff.max_group
    sum *= tariff.nineth_plan

  $('.sum span').html(accounting.formatMoney(sum, { symbol: 'руб.', format: '%v %s', thousand: ' ', precision: 0 }))

@init_range_handler = () ->
  range = $('div.range')
  return unless range.length

  tariff = eval($('table.tariff').data('tariff'))
  inputs = $('input.range')

  inputs.on 'change', ->
    target_class = if $(this).hasClass('month_count') then 'month_count' else 'group_count'
    $('.counter.'+target_class+' span').html($(this).val())
    set_sum(tariff)

  range.each (index, item) ->
    slider = $(item)
    slider.slider
      min: slider.data('min')
      max: slider.data('max')
      value: slider.data('init')
      step: slider.data('step')
      create: (event, ui) ->
        $('.'+$(event.target).attr('id')).val($(event.target).slider('value')).trigger('change')
      slide: (event, ui) ->
        $('.'+$(event.target).attr('id')).val(ui.value).trigger('change')
