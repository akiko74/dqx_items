window.DqxItems.DictionaryItem = class DictionaryItem extends Backbone.Model

  @dictionary_key: sha1.hex('dictionaries')

  defaults:
    name: null
    kana: null
    type: null

  initialize: (params) ->
    @set key: (DqxItems.DictionaryItem.dictionary_key + sha1.hex(@get 'name')) unless key?


  save: ->
    DqxItems.DataStorage.set(
      @get('key'),
      this
    )

  destroy: ->
    DqxItems.DataStorage.destroy(@get('key'))
    return @get('key')



  @findByKey: (key) ->
    return new DqxItems.DictionaryItem(DqxItems.DataStorage.get(key))

  @findByName: (item_name) ->
    console.log item_name
    _key = DqxItems.DictionaryItem.dictionary_key + sha1.hex(item_name)
    console.log _key
    return DqxItems.DictionaryItem.findByName(_key)

