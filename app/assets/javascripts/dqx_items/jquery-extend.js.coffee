
jQuery.fn.extend
  dqxItems: (options) ->
    settings =
      debug: false

    settings = jQuery.extend settings, options

    log = (msg) ->
      console?.log msg if settings.debug

    return @each ()->
      DqxItems.MyItemsFormBuilder.bind_functions()
      DqxItems.Dictionary.reload()
      DqxItems.MyItem.reload()

