@init_autcomplete = () ->
  autocompletes = $('.need_autocomplete:not(.charged)')

  autocompletes.each (index, item) ->
    input = $(item).addClass('charged')
    source = input.data('autocomplete-source')
    input.autocomplete
      source: source
      select: (evt, ui) ->
        if input.hasClass('with_id')
          link = $('.add_nested_fields', input.closest('.multicomplete'))
          link.click()
          input.val('')
          new_fileds = link.prev('.fields')
          $('.value', new_fileds).html(ui.item.link || ui.item.label)
          $('div.hidden input.hidden', new_fileds).val(ui.item.value)
          return false
