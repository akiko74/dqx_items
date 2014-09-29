window.DqxItems.Controllers.RecipeFinderController = \
class RecipeFinderController extends Marionette.Controller

  top: ->
    @dictionary = new DqxItems.Collections.DictionaryItemList
    @materials  = new DqxItems.Collections.RecipeFinderMaterialList
    @recipes    = new DqxItems.Collections.RecipeFinderRecipeList

    @recipes.on('remove', $.proxy(@onRemoveRecipe, @))
      .on('add', $.proxy(@onAddRecipe, @))

    recipeFinderForm = new DqxItems.Views.RecipeFinderFormView(
                         collection: @dictionary
                         recipes:    @recipes
                         materials:  @materials)
    recipesTable     = new DqxItems.Views.RecipeFinderRecipeListTableView(
                         collection: @recipes)
    materialsTable   = new DqxItems.Views.RecipeFinderMaterialListTableView(
                         collection: @materials)

    @layoutTop = new DqxItems.Views.RecipeFinderTopLayout
    @layoutTop.render()
    @layoutTop.form.show(recipeFinderForm)
    @layoutTop.recipeTable.show(recipesTable)
    @layoutTop.materialTable.show(materialsTable)


  onAddRecipe: (recipeModel, recipeCollection, option) ->
    for material in recipeModel.items
      if current = @materials.findWhere(name: material.name)
        current.set(count:(current.get('count') + material.count))
      else
        @materials.add(material)
    @layoutTop.materialTable.currentView.render()
    @layoutTop.trigger('recipeSync', @recipes)


  onRemoveRecipe: (recipeModel, recipeCollection, option) ->
    for material in recipeModel.items
      current = @materials.findWhere(name:material.name)
      if current.get('count') == material.count
        @materials.remove(current)
      else
        current.set(count: (current.get('count') - material.count))
    @layoutTop.materialTable.currentView.render()
    @layoutTop.trigger('recipeSync', @recipes)

