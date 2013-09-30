#jQuery.fn.extend
#  dqxItems: (options) ->
#    settings =
#      debug: false
#      dictionary: new DqxItems.DictionaryItemList()
#
#    settings = jQuery.extend settings, options
#
#    log = (msg) ->
#      console?.log msg if settings.debug
#
#    return @each ()->
#      DqxItems.MyItemsFormBuilder.bind_functions()
#      DqxItems.MyItem.reload()

do (jQuery) ->
  $ = jQuery

  $.fn.recipeFinder = (config) ->
    defaultConfig =
      debug: false
      recipeFinder: new DqxItems.RecipeFinder()


    options = $.extend(defaultConfig, config)

    @each () ->
      console.log 'Recipe Finder'
      options.recipeFinder.render()
      return @

  $.fn.myItemsOrganizer = (config) ->
    defaultConfig =
      debug: false
#      dictionary: new DqxItems.DictionaryItemList()

    options = $.extend(defaultConfig, config)

    @each () ->
      console.log 'My Items Organizer'
      console.log options
      return @

