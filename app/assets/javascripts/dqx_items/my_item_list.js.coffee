window.DqxItems.MyItemList = class MyItemList

  equipments: []
  items: []
  my_key: null

  constructor: () ->
    @equipments = new DqxItems.MyEquipmentList()
    @items      = new DqxItems.MyItemInventoryList()
    @my_key     = DqxItems.MyItem.my_key()

  @fetchFromStorage = () ->
    console.log 'fetch!'

  fetchFromStorage: () ->
    for val in DqxItems.DataStorage.keys()
      continue if ( ( val.search(@my_key) != 0 ) || ( val.length != 80 ) )
      my_item = DqxItems.MyItemFactory.findByKey(val)
      switch my_item.constructor.name

        when 'MyEquipment'
          @equipments.add(my_item)

        when 'MyItemInventory'
          @items.add(my_item)

    return this

