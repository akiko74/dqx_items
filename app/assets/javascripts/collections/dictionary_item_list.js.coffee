window.DqxItems.Collections.DictionaryItemList = \
class DictionaryItemList extends Backbone.Collection

  model: DqxItems.Models.DictionaryItem

  url: '/dictionaries.json'

  version: undefined
  dictionaryKey: undefined

  comparator: (item) ->
    return item.get('kana')

  fetch: (options = {}) ->
    options.beforeSend = $.proxy(@beforeSend, @)
    options.parse      = $.proxy(@parse, @)
    Backbone.Collection.prototype.fetch.call(@, options)


  beforeSend: (xhr, settings) ->
    dictionaryKey = DqxItems.Utils.CodeGenerator.generate('dictionaries')
    if versionRaw = DqxItems.Utils.DataStorage.raw_get(dictionaryKey)
      xhr.setRequestHeader('if-none-match', '"' + versionRaw + '"')
    true


  parse: (response, options) ->
    result = null
    if ( @virsion != null && options.xhr.getResponseHeader("Etag").replace(/['"]/gi,'') == @version )
      return @models
    else if options.xhr.status == 304
      return @fetchItemsFromStorage().models
    else if options.xhr.status == 200
      result = @reset(response)
      DqxItems.Utils.DataStorage.raw_set(
        DqxItems.Utils.CodeGenerator.generate('dictionaries'),
        options.xhr.getResponseHeader('ETag').replace(/['"]/gi,'')
      )
      return result.models
    else
      return []


  reset: (models) ->
    for row in DqxItems.Utils.DataStorage.keys()
      continue unless @isDictionaryItemRow(row)
      DqxItems.Utils.DataStorage.destroy(row)

    dictionaryItemList = new DqxItems.Collections.DictionaryItemList()

    _.each models, (model) ->
      dictionaryItem = new DqxItems.Models.DictionaryItem(model)
      dictionaryItem.save()
      dictionaryItemList.add dictionaryItem

    return dictionaryItemList


  isDictionaryItemRow: (row) ->
    ((row.indexOf(@dictionaryKey) == 0) && (row.length == 80))


  fetchItemsFromStorage: ->
    try
      for row in DqxItems.Utils.DataStorage.keys()
        continue unless @isDictionaryItemRow(row)
        @add(new DqxItems.Models.DictionaryItem(
          DqxItems.Utils.DataStorage.get(row)))
      @version = DqxItems.Utils.DataStorage.raw_get(@dictionaryKey)
      return @
    catch error
      @trigger 'error', error
      return null

  initialize: ->
    @version       = null
    @dictionaryKey = DqxItems.Utils.CodeGenerator.generate('dictionaries')
