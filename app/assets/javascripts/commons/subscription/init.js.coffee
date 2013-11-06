@init_subscription = () ->
  tariff_wrapper = $('.tariff_wrapper')

  return unless tariff_wrapper.length

  sliders = $('.slider', tariff_wrapper)
  tariff = tariff_wrapper.data('tariff')
  free_scale = (19*tariff.min_group)/6
  month_input = $('input.months_counter')
  group_input = $('input.groups_counter')

  calculate = () ->
    month = $(sliders).filter('.month')
    group = $(sliders).filter('.group')
    month_count = month.data('value') || month.slider('value')
    group_count = group.data('value') || group.slider('value')
    month_input.val(month_count)
    group_input.val(group_count)
    cost        = tariff.cost
    discount_hash = tariff.discount_hash
    sum = month_count * group_count
    $('.total .sum').html(accounting.formatMoney(sum*cost, { symbol: 'рублей', format: '%v %s', thousand: ' ', precision: 0 }))
    month.data('discount', 0)
    group.data('discount', 0)

    choose_plan = (month_count, group_count) ->
      month_count*group_count*(cost - Math.round(cost*discount(month_count, group_count)))

    discount = (month_count, group_count) ->
      month_index = index_member_of('months', month_count)
      group_index = index_member_of('groups', group_count)
      (month_discount(month_index)+group_discount(group_index))/100.0

    month_discount = (month_index) ->
      month.data('discount', discount_hash[month_index])
      discount_hash[month_index]

    group_discount = (group_index) ->
      group.data('discount', discount_hash[group_index])
      discount_hash[group_index]

    index_member_of = (kind, item) ->
      max = switch kind
        when 'months' then tariff.max_month
        when 'groups' then tariff.max_group
      arr = splitted_range([1..max])

      for items, index in arr
        return index+1 if (if item == max then item else item+1) in items

    each_slice = (arr, count) ->
      array = []
      for i in [0...arr.length] by count
        slice = arr[i...i+count]
        array.push slice
      array

    splitted_range = (range) ->
      each_slice(range, Math.round(range.length/tariff.divide_by))

    sum = choose_plan(month_count, group_count)

    group_count_string = group_count+' гр.'
    group_count_string += ' <span>(скидка ' + (group.data('discount') || 0) + '%)</span>' if group.data('discount') != 0
    month_count_string = month_count+' мес.'
    month_count_string += ' <span>(скидка ' + (month.data('discount') || 0) + '%)</span>' if month.data('discount') != 0
    discount_string = ''
    total_discount = month.data('discount')+group.data('discount')
    discount_string += '- '+total_discount+'%'
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
      max: if slider.hasClass('group') then slider.data('max')+free_scale else slider.data('max')
      value: slider.data('init')
      step: slider.data('step')
      slide: (event, ui) ->
        value = ui.value
        if slider.hasClass('group')
          if ui.value < (free_scale+tariff.min_group)
            value = 'меньше '+tariff.min_group+' '
          else
            value = ui.value - free_scale

        slider.data('value', value)
        calculate()
  calculate()

$ ->
  init_subscription()
