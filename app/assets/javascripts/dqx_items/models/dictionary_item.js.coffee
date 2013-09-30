window.DqxItems.DictionaryItem = class DictionaryItem extends Backbone.Model

  @dictionary_key: DqxItems.CodeGenerator.generate("dictionaries")

  idAttribute: "key"

  defaults:
    name: null
    kana: null
    type: null
    key:  null

  initialize: (params) ->
    @set key: (
      DqxItems.DictionaryItem.dictionary_key +
        DqxItems.CodeGenerator.generate(@get('name'))
    ) unless params?.key?


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
    _key = DqxItems.DictionaryItem.dictionary_key +
      DqxItems.CodeGenerator.generate(item_name)
    return DqxItems.DictionaryItem.findByKey(_key)

