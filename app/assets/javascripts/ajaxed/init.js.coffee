sort = (list) ->
  arr = list.children().get()

  arr.sort (a,b) ->
    a_value = parseInt($(a).text().match(/\d+/))
    b_value = parseInt($(b).text().match(/\d+/))

    if a_value < b_value
      return -1

    if a_value > b_value
      return 1

    return 0

  new_list = []

  arr.map (item, index) ->
    new_list.push(item) unless parseInt($(item).text().match(/\d+/)) == parseInt($(arr[arr.indexOf(item)+1]).text().match(/\d+/)) && !(arr.length == index+1)

  list.html(new_list)

@init_ajaxed = () ->
  $('.ajaxed').on 'ajax:complete', (evt, xhr) ->
    target = $(evt.target)
    if target.hasClass('new_link')
      target.hide()
      target.closest('.ajax_item').before('<li class="ajax_item">'+xhr.responseText+'</li>')
    else
      ul = target.closest('ul')
      ul.find('.new_link').show() unless xhr.responseText.match(/error/) || xhr.responseText.match(/new_link/)
      target.closest('.ajax_item').html(xhr.responseText)
      sort(ul)
