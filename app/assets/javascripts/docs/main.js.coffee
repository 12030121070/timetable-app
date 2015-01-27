class @SlyWrapper
  @all = []

  @find: (id) ->
    for item in @all
      return item if item.id == id
    null

  constructor: (item) ->
    SlyWrapper.all.push @
    @item = $(item)
    @position = @item.offset().top
    @id = "##{@item.attr('id')}"
    @link = $("#{@id.replace('#','\.')}_link")
    @link[0].sly_wrapper = @

  show: =>
    @link[0].object.activate()
    window.scrollTo(0, @position)

class @SidebarItem
  @all = []

  constructor: (item) ->
    SidebarItem.all.push @
    @item = $(item)
    @item[0].object = @
    @sly_wrapper = @item[0].sly_wrapper
    @item.on 'click', =>
      @activate()
      window.location.hash = @item.children('a').attr('href').match(/#.+/)[0]
      false

  activate: =>
    @item.addClass('active').siblings().removeClass('active')

$ ->
  sidebar = $('.js-sidebar')
  return unless sidebar.length

  content = $('.content')
  init_gallery()
  init_sticky_sidebar()

  for item in $('.sly_wrapper')
    new SlyWrapper item

  for item in sidebar.children('.item')
    new SidebarItem item

  $(window).on 'scroll', ->
    current_position = $(window).scrollTop()
    for item in SidebarItem.all
      item.activate() if current_position >= item.sly_wrapper.position

  setTimeout (->
    SlyWrapper.find(window.location.hash || '#about').show()
  ), 500
