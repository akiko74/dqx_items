window.DqxItems.MyItemList = class MyItemList extends Backbone.Collection

  url: '/my/items.json'

  equipments: null
  items: null
  myKey: null
  version: undefined

  constructor: () ->
    if !DqxItems.MyItemList.instance
      @equipments = new DqxItems.MyEquipmentList()
      @items      = new DqxItems.MyItemInventoryList()
      @myKey      = DqxItems.DataStorage.raw_get("my_key")
      DqxItems.MyItemList.instance = @
      Backbone.Collection.apply(DqxItems.MyItemList.instance, arguments)
    return DqxItems.MyItemList.instance


  fetch: (options = {}) ->
    options.beforeSend = $.proxy(@beforeSend)
    options.parse      = $.proxy(@parse,@)
    options.complete   = $.proxy(@complete,@)
    Backbone.Collection.prototype.fetch.call(@,options)

  beforeSend: (xhr, settings) ->
    @myKey = DqxItems.DataStorage.raw_get("my_key")
    if etag = DqxItems.DataStorage.raw_get(@myKey)
      @version = etag.replace(/['"]/gi,'')
      xhr.setRequestHeader('if-none-match', '"' + etag + '"')

  complete: (xhr, textStatus) ->
    DqxItems.DataStorage.raw_set(
      @myKey,
      xhr.getResponseHeader('ETag').replace(/['"]/gi,'')
    ) if (textStatus == 'success')

  parse: (response, options) ->
    if response
      @reset(response)
    else
      @fetchItemsFromStorage()


  reset: (response) ->
    DqxItems.MyItemList.instance          = undefined
    DqxItems.MyItemInventoryList.instance = undefined
    DqxItems.MyEquipmentList.instance     = undefined
    DqxItems.DataStorage.raw_set("my_key", response.uid)
    @myKey = DqxItems.DataStorage.raw_get("my_key")
    for row in DqxItems.DataStorage.keys()
      continue if ( !(row.indexOf(@myKey) == 0) || (row.length != 80) )
      DqxItems.DataStorage.destroy(row)

    myItemList = new DqxItems.MyItemList()

    _.each response.equipments, (equipment) ->
      myEquipment = new DqxItems.MyEquipment(equipment)
      myEquipment.save()
      myItemList.equipments.add myEquipment

    _.each response.items, (item) ->
      myItemInventory = new DqxItems.MyItemInventory(item)
      myItemInventory.save()
      myItemList.items.add myItemInventory

    return []


  tmpFunc: () ->
    if !DqxItems.MyItemList.instance
      console.log 'instance undefined.'
      dictionary  = new DqxItems.DictionaryItemList()
      @equipments = new DqxItems.MyEquipmentList()
      @items      = new DqxItems.MyItemInventoryList()
      @myKey     = DqxItems.MyItem.my_key()
      console.log dictionary
      console.log @equipments
      console.log @items
      console.log @myKey
      console.log 'start fetch'

      this.fetch
        beforeSend: (xhr, settings) ->
          console.log 'beforeSend'
          console.log xhr
          #etag = DqxItems.DataStorage.raw_get(@dictionaryKey)
          #if etag
          #  xhr.setRequestHeader('if-none-match', etag);
        complete: (xhr, textStatus) ->
          console.log 'complete'
          console.log textStatus
          #if (textStatus == 'success')
          #  DqxItems.DataStorage.raw_set(
          #    @dictionaryKey,
          #    xhr.getResponseHeader('ETag')
          #  )

      console.log 'fetched.'
      console.log @equipments
      console.log @items
      DqxItems.MyItemList.instance = this
      Backbone.Collection.apply(DqxItems.MyItemList.instance, arguments)
    console.log DqxItems.MyItemList.instance
    return DqxItems.MyItemList.instance

  fetchItemsFromStorage: () ->
    console.log '@fetchItemsFromStorage'
    models = []
    @myKey = DqxItems.MyItem.my_key()
    console.log "@mKey : #{@myKey}"
    for row in DqxItems.DataStorage.keys()
      continue if ( !(row.indexOf(@myKey) == 0) || (row.length != 80) )
      my_item = DqxItems.MyItemFactory.findByKey(row)
      console.log "row: #{row}"
      switch my_item.constructor.name
        when 'MyEquipment'
          @equipments.add(my_item)
        when 'MyItemInventory'
          @items.add(my_item)
    console.log @
    return this

