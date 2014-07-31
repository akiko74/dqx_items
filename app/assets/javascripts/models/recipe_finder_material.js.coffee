window.DqxItems.Models.RecipeFinderMaterial = class RecipeFinderMaterial extends Backbone.Model

  defaults:
    name: undefined
    unitprice: -1
    count: -1

  initialize: ->
    @name      = @get('name')
    @unitprice = @get('unitprice')
    @count     = @get('count')

    throw new Error("name is required !") unless @name?

    @key = DqxItems.Utils.CodeGenerator.generate("materials") +
      DqxItems.Utils.CodeGenerator.generate(@name)

