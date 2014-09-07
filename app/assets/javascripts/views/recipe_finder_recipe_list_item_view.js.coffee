window.DqxItems.Views.RecipeFinderRecipeListItemView = \
class RecipeFinderRecipeListItemView extends Marionette.ItemView

  template: JST['recipe_finder_recipe_list_item']
  tagName: "tr"

  onRender: ->
    @$el.find('.btn').on 'click', $.proxy(@clickRemoveBtn, @)

  clickRemoveBtn: ->
    @model.collection.remove(@model)
