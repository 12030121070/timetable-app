set_sum = (tariff) ->
  month_count = parseInt($('input.month_count').val())
  group_count = parseInt($('input.group_count').val())
  sum = month_count * group_count

  if month_count >= tariff.min_month && month_count < tariff.half_months && group_count >= tariff.min_group && group_count < tariff.half_groups
    sum *= tariff.first_plan
  else if month_count >= tariff.min_month && month_count < tariff.half_months && group_count >= tariff.half_groups && group_count < tariff.max_group
    sum *= tariff.second_plan
  else if month_count >= tariff.min_month && month_count < tariff.half_months && group_count >= tariff.max_group
    sum *= tariff.third_plan
  else if month_count >= tariff.half_months && month_count < tariff.max_month && group_count >= tariff.min_group && group_count < tariff.half_groups
    sum *= tariff.fourth_plan
  else if month_count >= tariff.half_months && month_count < tariff.max_month && group_count >= tariff.half_groups && group_count < tariff.max_group
    sum *= tariff.fith_plan
  else if month_count >= tariff.half_months && month_count < tariff.max_month && group_count >= tariff.max_group
    sum *= tariff.sixth_plan
  else if month_count >= tariff.max_month && group_count >= tariff.min_group && group_count < tariff.half_groups
    sum *= tariff.seventh_plan
  else if month_count >= tariff.max_month && group_count >= tariff.half_groups && group_count < tariff.max_group
    sum *= tariff.eighth_plan
  else if month_count >= tariff.max_month && group_count >= tariff.max_group
    sum *= tariff.nineth_plan

  $('.sum .total').html(sum)

@init_range_handler = () ->
  range = $('input.range')
  tariff = eval($('table.tariff').data('tariff'))
  return unless range.length

  range.each (index, item) ->
    $(item).after('<span class="counter"/>')

  range.on 'change', ->
    $this = $(this)
    $this.next('.counter').html($this.val())
    set_sum(tariff)

  range.each (index, item) ->
    $this = $(item)
    $this.val($this.data('init')).trigger('change')
