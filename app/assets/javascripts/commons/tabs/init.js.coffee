@init_tabs = () ->
  tabs = $('.tabs:not(.charged)')
  tabs.each (index, item) ->
    tab = $(item).addClass('charged')

    $('.error', '.lesson_time_block').each (index, item) ->
      $('.'+$(item).closest('.lesson_time_block').attr('id'), tabs).parent('li').addClass('error_tab')

    tab.on 'click', (evt) ->
      $target = $(evt.target)
      if $target.hasClass('tab_nav')
        $target.parent('li').addClass('active').siblings('li').removeClass('active')
        $('#'+$target.attr('class').match(/lesson_time_for_\d+/)).show().siblings('.lesson_time_block').hide()
        false

  $('.day_nav li:first a', tabs).click()
