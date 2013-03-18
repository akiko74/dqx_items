jQuery ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()
  #$('#keyword').typeahead({source: itemList, items:5});
  $('#recipes_keyword').typeahead({source: recipesList, items:5});
  $('.dropdown-toggle').dropdown();


