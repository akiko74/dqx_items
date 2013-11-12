jQuery ->
  console.log 'on ready.'
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()
  $('.dropdown-toggle').dropdown()
#  $("#my_items_update_form").dqxItems
#    debug: true

  new DqxItems.Initializer()
  $('#recipe_finder').recipeFinder()
  $('#my_items_organizer').myItemsOrganizer()

  DqxItems.Initializer.appendAffiliate()





jQuery(document).on 'page:change', ->
  console.log 'on page change.'
  new DqxItems.Initializer()

jQuery(window).on 'resize', ->
  #console.log "resize to #{jQuery('body').css('width')}"
  DqxItems.Initializer.adjustWindow(jQuery('body').css('width'))
