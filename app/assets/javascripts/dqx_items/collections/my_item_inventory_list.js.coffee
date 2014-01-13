window.DqxItems.MyItemInventoryList = class MyItemInventoryList extends Backbone.Collection
  model: DqxItems.MyItemInventory

  constructor: () ->
    if !DqxItems.MyItemInventoryList.instance
      DqxItems.MyItemInventoryList.instance = @
      Backbone.Collection.apply(DqxItems.MyItemInventoryList.instance, arguments)
    return DqxItems.MyItemInventoryList.instance


