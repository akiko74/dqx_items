window.DqxItems.RecipeList = class RecipeList extends Backbone.Collection

  model: DqxItems.Recipe

  materialList: undefined


  initialize: () ->
    @materialList = new DqxItems.MaterialList()
    @on('remove', @removeItem, @)
    @on('add',    @addItem, @)


  removeItem: (model) ->
    for item in model.items
      material = @materialList.findWhere(name: item.name)
      material.count -= item.count
      if item.unitprice > 0
        material.unitprice -= (item.unitprice * item.count)
      else
        material.unitprice = -1
      material.trigger('change')


  addItem: (model) ->
    for item in model.items
      if material = @materialList.findWhere(name: item.name)
        if item.unitprice > 0
          material.unitprice += (item.unitprice * item.count)
        else
          material.unitprice = -1
        material.count += item.count
        material.trigger('change')
      else
        @materialList.add(item)
    return @
