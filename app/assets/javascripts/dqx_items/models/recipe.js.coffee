window.DqxItems.Recipe = class Recipe extends Backbone.Model
  defaults: {
    'name': undefined
    'price': -1
    'items': []
  }
  attributes: {}
  dictionary: undefined

  constructor: (params) ->
    @name = params.name
    $.getJSON(
      "/recipes.json",
      { recipes : [params.name] },
      $.proxy(@parse, @)
    )
    unless @dictionary = params.dictionary
      @dictionary = (new DqxItems.DictionaryItemList()).where({name:item})[0]

  parse: (result) ->
    recipeData  = result.recipe_list[0]
    @price      = recipeData.price
    @items      = recipeData.items
    @attributes = { name:@name, price:@price, items:@items }
    _.each @items, (item) ->
      DqxItems.MaterialList.addMaterial(item)
    @

  destroy: (options={}) ->
    console.log 'DqxItems.Recipe#destroy()'
