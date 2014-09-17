window.DqxItems.Views.RecipeFinderMaterialListTableView = \
class RecipeFinderMaterialListTableView \
extends Backbone.Marionette.CompositeView

  template:  JST['recipe_finder_material_list_table']
  childView:  DqxItems.Views.RecipeFinderMaterialListItemView
  childViewContainer: 'tbody'

