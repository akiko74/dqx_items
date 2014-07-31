window.DqxItems.Controllers.RecipeFinderController = \
class RecipeFinderController extends Marionette.Controller

  top: ->
    dictionary = new DqxItems.Collections.DictionaryItemList
    materials  = new DqxItems.Collections.RecipeFinderMaterialList
    recipes    = new DqxItems.Collections.RecipeFinderRecipeList
    layout     = new DqxItems.Views.RecipeFinderTopLayout

    layout.render()
    layout.form.show(
      new DqxItems.Views.RecipeFinderFormView(
        collection: dictionary,
        recipes:    recipes,
        materials:  materials ))
    layout.recipeTable.show(
      new DqxItems.Views.RecipeFinderRecipeListTableView(
        collection: recipes ))
    layout.materialTable.show(
      new DqxItems.Views.RecipeFinderMaterialListTableView(
        collection: materials ))

    dictionary.fetch()

