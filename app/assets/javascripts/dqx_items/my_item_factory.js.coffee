window.DqxItems.MyItemFactory = class MyItemFactory

  @createMyItem = (item_data) ->
    if item_data.renkin_count?
      return new DqxItems.MyEquipment(item_data)
    else
      return new DqxItems.MyItemInventory(item_data)

  @findByKey = (key) ->
    _my_item = DqxItems.DataStorage.get(key)
    _my_item.key = key
    return @createMyItem(_my_item)
