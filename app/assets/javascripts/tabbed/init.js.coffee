@init_tabbed = () ->
  $('.tabbed ul:not(:first)').hide()
  $('.tabbed_link:first').parent('li').addClass('active')
  $('.tabbed_link').on 'click', ->
    $('.tabbed_link').parent('li').removeClass('active')
    $(this).parent('li').addClass('active')
    $('.target').hide()
    $('.'+$(this).attr('id')).show()
    false
