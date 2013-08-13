@init_scrollable = () ->
  scrollable = $('.scrollable:not(.charged)')
  if scrollable.length
    scrollable.each (index, item) ->
      $item = $(item)
      $item.addClass('charged')
      parent = $item.parent()
      siblings_height = 0

      $item.siblings().each (index, item) ->
        siblings_height += $(item).outerHeight(true)

      item_height = parent.height() - siblings_height
      $item.css('height', item_height)
      $item.css('overflow-y', 'scroll')

      stickies = $('.sticky', $item)

      $item.on 'scroll', (evt) ->
        stickies.each (index, item) ->
          sticky = $(item)
          sticky_height = sticky.height()

          if $item.scrollTop() + item_height == $item[0].scrollHeight
            if sticky.hasClass('bottom')
              $('.bottom_empty', $item).css('height', 0)
              sticky.removeClass('sticky')
          else
            if sticky.hasClass('bottom')
              sticky.addClass('sticky')
              $('.bottom_empty', $item).css('height', sticky_height)

