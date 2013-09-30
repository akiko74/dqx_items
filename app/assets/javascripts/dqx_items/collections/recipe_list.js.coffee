window.DqxItems.RecipeList = class RecipeList extends Backbone.Collection

  model: DqxItems.Recipe

  comparator: (item) ->
    return item.get('kana')

  constructor: () ->
    if !DqxItems.RecipeList.instance
      DqxItems.RecipeList.instance = this
      Backbone.Collection.apply(DqxItems.RecipeList.instance, arguments)
    return DqxItems.RecipeList.instance


  @addRecipe: (recipe) ->
    (new DqxItems.RecipeList()).trigger('add', recipe)

  @removeRecipe: (recipe) ->
    (new DqxItems.RecipeList()).remove recipe
