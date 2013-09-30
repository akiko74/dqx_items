window.DqxItems.MyItemList = class MyItemList extends Backbone.Collection

  #model: DqxItems.DictionaryItem

  url: '/my/items.json'

  equipments: null
  items: null
  myKey: null

  constructor: () ->
    @equipments = new DqxItems.MyEquipmentList()
    @items      = new DqxItems.MyItemInventoryList()
    @myKey      = DqxItems.DataStorage.raw_get("my_key")

  fetch: (options = {}) ->
    options.beforeSend = @beforeSend
    options.parse      = @parse
    Backbone.Collection.prototype.fetch.call(@,options)

  beforeSend: (xhr, settings) ->
    console.log 'beforeSend'
    console.log xhr
    etag = DqxItems.DataStorage.raw_get(@myKey)
    console.log etag
    xhr.setRequestHeader('if-none-match', etag) if etag

  parse: (response, options) ->
    console.log 'parse!!!!'
    if options.xhr.status == 200
      console.log 'return 200'
      DqxItems.DataStorage.raw_set("my_key", response.uid)
      @myKey = DqxItems.DataStorage.raw_get("my_key")
      DqxItems.DataStorage.raw_set(@myKey, options.xhr.getResponseHeader('ETag'))

      @fetchItemsFromStorage().map (item) ->
        item.destroy()

      _models = []
      for item in response.equipments
        _models.push item
        @equipments.add (new DqxItems.MyEquipment(item)).save()
      for item in response.items
        _models.push item
        @items.add (new DqxItems.MyItemInventory(item)).save()
      return _models

    else if options.xhr.status == 304
      if @models.length == 0
        return @fetchItemsFromStorage()
      else
        return @models
    else
      return @fetchItemsFromStorage()




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
    dictionary_key = DqxItems.DictionaryItem.dictionary_key
    for row in DqxItems.DataStorage.keys()
      continue if ( !(row.indexOf(dictionary_key) == 0) || (row.length != 80) )
      my_item = DqxItems.MyItemFactory.findByKey(val)
      switch my_item.constructor.name
        when 'MyEquipment'
          @equipments.add(my_item)
        when 'MyItemInventory'
          @items.add(my_item)
    console.log @
    return this

