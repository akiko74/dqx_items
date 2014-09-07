jQuery ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()
  $('#keyword').typeahead({source: itemList, items:10})
  $('#recipes_keyword').typeahead({source: recipesList, items:10})
  $('.dropdown-toggle').dropdown()


