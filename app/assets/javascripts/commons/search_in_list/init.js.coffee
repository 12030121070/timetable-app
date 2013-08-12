@init_search = () ->
  inputs = $('.search_in_list:not(.charged)')
  $('.hidden_value').hide()

  if inputs.length
    inputs.each (index, item) ->
      $item = $(item)
      add_link = $item.next('a')
      $item.addClass('charged')
      list = new List($('.scrollable')[0], {
        valueNames: ['hidden_value']
        searchClass: 'search_in_list'
      })
      list.on 'updated', ->
        if list.matchingItems.length == 0
          $(list.list).append('<li class="empty">Ничего не найдено</li>')
        else
          $('.empty', list.list).remove()

      add_link.on 'click', ->
        val = $item.val()
        if val.length > 0
          $('.empty', list.list).remove()
          $('.add_nested_fields', list.listContainer).click()
          added_li = $('li:last', list.list)
          $('div input', added_li).val(val)
          $item.val('')
          list.addItems([added_li[0]],['hidden_value'])
          list.search('')
        false
