window.DqxItems.DictionaryItemList = class DictionaryItemList extends Backbone.Collection

  model: DqxItems.DictionaryItem

  url: '/dictionaries.json'
  version: undefined

  dictionaryKey: undefined

  comparator: (item) ->
    return item.get('kana')

  fetch: (options = {}) ->
    options.beforeSend = @beforeSend
    options.parse      = $.proxy(@parse,@)
    options.complete   = @complete
    Backbone.Collection.prototype.fetch.call(@,options)


  beforeSend: (xhr, settings) ->
    dictionaryKey = DqxItems.CodeGenerator.generate('dictionaries')
    @version = (DqxItems.DataStorage.raw_get(dictionaryKey)).replace(/['"]/gi,'')
    xhr.setRequestHeader('if-none-match', @version) if @version

  complete: (xhr, textStatus) ->
    DqxItems.DataStorage.raw_set(
      DqxItems.CodeGenerator.generate('dictionaries'),
      xhr.getResponseHeader('ETag').replace(/['"]/gi,'')
    ) if (textStatus == 'success')


  parse: (response,options) ->
    @reset(response)


  reset: (models) ->
    DqxItems.DictionaryItemList.instance = undefined
    dictionary_key = DqxItems.DictionaryItem.dictionary_key
    for row in DqxItems.DataStorage.keys()
      continue if ( !(row.indexOf(dictionary_key) == 0) || (row.length != 80) )
      DqxItems.DataStorage.destroy(row)

    dictionaryItemList = new DqxItems.DictionaryItemList()

    _.each models, (model) ->
      dictionaryItem = new DqxItems.DictionaryItem(model)
      dictionaryItem.save()
      dictionaryItemList.add dictionaryItem

    return dictionaryItemList




  constructor: () ->
    @dictionaryKey = DqxItems.CodeGenerator.generate('dictionaries')
    if !DqxItems.DictionaryItemList.instance
      DqxItems.DictionaryItemList.instance = this
      Backbone.Collection.apply(DqxItems.DictionaryItemList.instance, arguments)
    return DqxItems.DictionaryItemList.instance


  fetchItemsFromStorage: () ->
    dictionary_key = DqxItems.DictionaryItem.dictionary_key
    for row in DqxItems.DataStorage.keys()
      continue if ( !(row.indexOf(dictionary_key) == 0) || (row.length != 80) )
      @add DqxItems.DataStorage.get(row)
    return @

