window.DqxItems.RecipeTable = class RecipeTable extends Backbone.View

  el:"#recipe_table"
  template: _.template($("#tmpl-recipe_table").html())


  initialize: ->
    @collection.on('add', @addItem, @)
    @collection.on('remove', @removeItem, @)


  addItem: ->
    if @$el.find("#default_contents").css("display") == 'block'
      @$el.find("#recipe_materials").slideDown(300)
      @$el.find("#default_contents").fadeOut(100)

  removeItem: ->
    if @collection.length == 0
      @$el.find("#recipe_materials").slideUp(300)
      @$el.find("#default_contents").fadeIn(100)

  render: () ->
    @$el.html(@template())
    if @collection.length == 0
      @$el.find("#default_contents").fadeIn(200)
    else
      @$el.find("#recipe_materials").slideDown(300)
    (new DqxItems.RecipeListTable({
      collection:@collection
    })).render()
    (new DqxItems.MaterialListTable({
      collection:@collection.materialList
    })).render()

