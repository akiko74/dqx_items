window.DqxItems.Models.RecipeFinderRecipe = \
class RecipeFinderRecipe extends Backbone.Model

  url: "/recipes.json",

  idAttribute: "name"

  defaults:
    name: undefined
    price: -1
    items: []
    key: null

  initialize: ->
    @price = @get('price')
    @name  = @get('name')
    @dictionary = @get('dictionary')
    @items = new Array()
    @bazaar = false

    throw new Error("name is required !") unless @name?
    throw new Error("dictionary is required !") unless @dictionary?
    throw new Error("#{@name} is unknown !") unless @dictionary.findWhere(name:@name)

    @key   = DqxItems.Utils.CodeGenerator.generate("recipes") +
      DqxItems.Utils.CodeGenerator.generate(@name)
    @set('key', @key)
    @set('bazaar', @bazaar)


  fetch: (options = {}) ->
    options.data = { recipes : [@name] }
    Backbone.Model.prototype.fetch.call(@, options)


  parse: (response, options) ->
    @price = response.recipe_list[0].price
    for item in response.recipe_list[0].items
      item.dictionary = @dictionary.findWhere({name:item.name})
      @items.push(new DqxItems.Models.RecipeFinderMaterial(item))
      @bazaar = ( @bazaar || ( item.unitprice == 0 ))
    @set('bazaar', @bazaar)
    response.recipe_list[0]

