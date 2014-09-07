window.DqxItems.Controllers.RecipeFinderController = \
class RecipeFinderController extends Marionette.Controller

  top: ->
    @dictionary = new DqxItems.Collections.DictionaryItemList
    @materials  = new DqxItems.Collections.RecipeFinderMaterialList
    @recipes    = new DqxItems.Collections.RecipeFinderRecipeList

    @recipes.on('remove', $.proxy(@onRemoveRecipe, @))
      .on('add', $.proxy(@onAddRecipe, @))

    layout = new DqxItems.Views.RecipeFinderTopLayout
    layout.render()
    layout.form.show(
      new DqxItems.Views.RecipeFinderFormView(
        collection: @dictionary,
        recipes:    @recipes,
        materials:  @materials ))
    layout.recipeTable.show(
      new DqxItems.Views.RecipeFinderRecipeListTableView(
        collection: @recipes ))
    layout.materialTable.show(
      new DqxItems.Views.RecipeFinderMaterialListTableView(
        collection: @materials ))

    @dictionary.fetch()


  onAddRecipe: (recipeModel, recipeCollection, option) ->
    for material in recipeModel.items
      if current = @materials.findWhere(name: material.name)
        current.count = current.count + material.count
      else
        @materials.add(material)
    console.log @materials

  onRemoveRecipe: (recipeModel, recipeCollection, option) ->
    console.log JSON.stringify @materials
    for material in recipeModel.items
      current = @materials.findWhere(name:material.name)
      if current.count == material.count
        @materials.remove(current)
      else
        current.count = current.count - material.count
    console.log @materials

