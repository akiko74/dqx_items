window.DqxItems.DictionaryItemList = class DictionaryItemList extends Backbone.Collection

  model: DqxItems.DictionaryItem

  url: '/dictionaries.json'

  dictionaryKey: sha1.hex('dictionaries')

  parse: (response,xhr) ->
    if xhr.xhr.status == 200
      console.log response
      @fetchItemsFromStorage().map (item) ->
        item.destroy()
      response.map (item) ->
        (new DqxItems.DictionaryItem(item)).save()
      return response.data
    else if xhr.xhr.status == 304
      if this.models.length == 0
        return @fetchItemsFromStorage()
      else
        return this.models
    else
      return @fetchItemsFromStorage()


  beforeSend: (xhr, settings) ->
    etag = DqxItems.DataStorage.raw_get(@dictionaryKey)
    if etag
      xhr.setRequestHeader('if-none-match', etag);

  complete: (xhr, textStatus) ->
    if (textStatus == 'success')
      DqxItems.DataStorage.raw_set(
        @dictionaryKey,
        xhr.getResponseHeader('ETag')
      )

  constructor: () ->
    if !DqxItems.DictionaryItemList.instance
      this.fetch({
        beforeSend : this.beforeSend.bind(this),
        complete : this.complete.bind(this)
      })
      DqxItems.DictionaryItemList.instance = this
      Backbone.Collection.apply(DqxItems.DictionaryItemList.instance, arguments)
    return DqxItems.DictionaryItemList.instance

  fetchItemsFromStorage: () ->
    models = []
    dictionary_key = DqxItems.DictionaryItem.dictionary_key
    for row in DqxItems.DataStorage.keys()
      continue if ( !(row.indexOf(dictionary_key) == 0) || (row.length != 80) )
      models.push (new DqxItems.DictionaryItem(DqxItems.DataStorage.get(row)))
    return models

