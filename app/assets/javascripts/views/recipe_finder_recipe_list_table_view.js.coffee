window.DqxItems.Views.RecipeFinderRecipeListTableView = \
class RecipeFinderRecipeListTableView extends Marionette.CompositeView

  template:  JST['recipe_finder_recipe_list_table']
  childView:  DqxItems.Views.RecipeFinderRecipeListItemView
  childViewContainer: 'tbody'

