
jQuery.fn.extend
  dqxItems: (options) ->
    settings =
      debug: false

    settings = jQuery.extend settings, options

    log = (msg) ->
      console?.log msg if settings.debug

    return @each ()->
      log "Preparing magic show."
      data = new DqxItems.MyItemsFormData
                   itemCost: "",
                   renkinTotalCost: 2
      log data
      log "-----"
      log data.checkItemAddable()
      log data.checkItemDeletable()
      log "Option 1 value: #{settings.option1}"
#      dqx_items = new DqxItems.Dictionary
#      log dqx_items
      console.log "##############################"
      DqxItems.MyItemsFormBuilder.bind_functions()
      DqxItems.Dictionary.reload()
      DqxItems.MyItem.reload()

