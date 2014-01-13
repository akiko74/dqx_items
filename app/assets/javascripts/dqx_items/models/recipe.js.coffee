window.DqxItems.Recipe = class Recipe extends Backbone.Model

  @recipe_key: DqxItems.CodeGenerator.generate("recipes")

  defaults: {
    'name': undefined
    'price': -1
    'items': []
  }
  attributes: {}
  dictionary: undefined
  items: []

  constructor: (params) ->
    @id = DqxItems.Recipe.recipe_key +
      DqxItems.CodeGenerator.generate(params.name)
    @name = params.name
    unless @dictionary = params.dictionary
      @dictionary = (new DqxItems.DictionaryItemList()).where({name:params.name})[0]
    $.ajax({
      url: "/recipes.json",
      dataType: 'json',
      async: false,
      data: { recipes : [params.name] },
      success: $.proxy(@parse, @)
    })

  parse: (result) ->
    recipeData  = result.recipe_list[0]
    @price      = recipeData.price
    @items      = recipeData.items
    @attributes = { name:@name, price:@price, items:@items, id:@id }
    return @

