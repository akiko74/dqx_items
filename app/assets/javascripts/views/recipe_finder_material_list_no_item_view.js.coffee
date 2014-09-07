window.DqxItems.Views.RecipeFinderMaterialListNoItemView = \
class RecipeFinderMaterialListNoItemView \
extends Backbone.Marionette.ItemView

  template: JST['recipe_finder_material_list_no_item']
  tagName: "tr"

  initialize: ->
    console.log 'init'

