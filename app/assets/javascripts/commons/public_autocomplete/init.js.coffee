init_public_autocomplete = () ->
  form = $('.search_form')
  $('.need_autocomplete', form).autocomplete
    source: form.attr('action')
    select: (evt, ui) ->
      $(evt.target).val(ui.item.value)
      form.submit()

$ ->
  init_public_autocomplete()
