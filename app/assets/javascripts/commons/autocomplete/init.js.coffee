@init_autcomplete = () ->
  autocompletes = $('.need_autocomplete:not(.charged)')

  autocompletes.each (index, item) ->
    input = $(item).addClass('charged')
    source = input.data('autocomplete-source')
    input.autocomplete
      source: source
      focus: (evt, ui) ->
        $(evt.target).val ui.item.label
        return false

      select: (evt, ui) ->
        if input.hasClass('with_id')
          existing = []
          fields =  $('.fields', input.closest('.multicomplete'))

          for itm in fields
            itm_val = $('.value', itm).text()
            existing.push ui.item.label if ui.item.label.match(new RegExp("^#{itm_val.replace(')', '\\)').replace('(', '\\(')}.*"))

          if existing.length

          else
            link = $('.add_nested_fields', input.closest('.multicomplete'))
            link.click()
            new_fileds = link.prev('.fields')
            $('.value', new_fileds).html(ui.item.link || ui.item.label)
            $('div.hidden input.hidden', new_fileds).val(ui.item.value)

          $(evt.target).val('')
          return false
