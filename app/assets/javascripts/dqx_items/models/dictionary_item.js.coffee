window.DqxItems.DictionaryItem = class DictionaryItem extends Backbone.Model

  @dictionary_key: CryptoJS.SHA1("dictionaries").toString()

  defaults:
    name: null
    kana: null
    type: null

  initialize: (params) ->
    @set key: (DqxItems.DictionaryItem.dictionary_key + CryptoJS.SHA1(@get('name')).toString()) unless key?


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
    _key = DqxItems.DictionaryItem.dictionary_key + CryptoJS.SHA1(item_name).toString()
    return DqxItems.DictionaryItem.findByKey(_key)

