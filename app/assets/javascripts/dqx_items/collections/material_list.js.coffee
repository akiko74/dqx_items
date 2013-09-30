window.DqxItems.MaterialList = class MaterialList extends Backbone.Collection

  model: DqxItems.Material

  comparator: (item) ->
    return item.get('kana')

  constructor: () ->
    if !DqxItems.MaterialList.instance
      DqxItems.MaterialList.instance = this
      Backbone.Collection.apply(DqxItems.MaterialList.instance, arguments)
    return DqxItems.MaterialList.instance


  @removeMaterial: (item) ->
    materialList = new DqxItems.MaterialList()
    if material = materialList.findWhere({name:item.name})
      if (material.get('count') - item.count) == 0
        material.trigger('destroy')
      else if (material.get('count') - item.count) > 0
        material.set({
          count: (material.get('count') - item.count),
          unitprice: (material.get('unitprice') - item.unitprice)
        })
    return materialList


  @addMaterial: (item) ->
    materialList = new DqxItems.MaterialList()
    if material = materialList.findWhere({name:item.name})
      material.set({
        count: (material.get('count') + item.count),
        unitprice: (material.get('unitprice') + item.unitprice)
      })
    else
      material = new DqxItems.Material(item)
      materialList.add material
    return materialList

