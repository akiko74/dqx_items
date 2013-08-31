
jQuery.fn.extend
  dqxItems: (options) ->
    settings =
      debug: false
      dictionary: new DqxItems.DictionaryItemList()

    settings = jQuery.extend settings, options

    log = (msg) ->
      console?.log msg if settings.debug

    return @each ()->
      DqxItems.MyItemsFormBuilder.bind_functions()
      DqxItems.MyItem.reload()


