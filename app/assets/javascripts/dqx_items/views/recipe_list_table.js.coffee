window.DqxItems.RecipeListTable = class RecipeListTable extends Backbone.View

  el:"#recipe_list_table"
  template: _.template($("#tmpl-recipe_list_table").html())

  events:'click .all_remove_button':'allRemove'


  initialize: (options) ->
    @collection.on('add', @addRow, @)

  allRemove: (e) ->
    @collection.remove @collection.models
    return false

  render: () ->
    @$el.html(@template())
    return @

  addRow: ->
    tbody = @$el.find('tbody').html('')
    for material in @collection.models
      tbody.append (new DqxItems.RecipeTableRow({model:material, collection:@collection})).render()
    console.log @collection
    return @collection

