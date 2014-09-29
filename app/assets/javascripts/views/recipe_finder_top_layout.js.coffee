window.DqxItems.Views.RecipeFinderTopLayout = \
class RecipeFinderTopLayout extends Marionette.LayoutView

  el: '#recipe_finder'

  template: JST['recipe_finder']

  regions:
    form:          '#recipe_finder_form_wrapper'
    recipeTable:   '#recipe_table'
    materialTable: '#material_table'

  ui:
    tables: '#have_content'
    noInfo: '#no_content'

  initialize: (options) ->
    @on('recipeSync', @onRecipeSynced)

  onRecipeSynced: (recipes) ->
    if recipes.length > 0
      @ui.tables.show()
      @ui.noInfo.hide()
    else
      @ui.tables.hide()
      @ui.noInfo.show()


  onRender: ->
    @ui.tables.hide()
    @ui.noInfo.show()

