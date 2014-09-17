window.DqxItems.Views.RecipeFinderTopLayout = \
class RecipeFinderTopLayout extends Marionette.LayoutView

  el: '#recipe_finder'

  template: JST['recipe_finder']

  regions:
    form:          '#recipe_finder_form_wrapper'
    recipeTable:   '#recipe_table'
    materialTable: '#material_table'

