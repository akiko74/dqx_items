window.DqxItems.MyEquipmentList = class MyEquipmentList extends Backbone.Collection
  model: DqxItems.MyEquipment

  constructor: () ->
    if !DqxItems.MyEquipmentList.instance
      DqxItems.MyEquipmentList.instance = @
      Backbone.Collection.apply(DqxItems.MyEquipmentList.instance, arguments)
    return DqxItems.MyEquipmentList.instance


