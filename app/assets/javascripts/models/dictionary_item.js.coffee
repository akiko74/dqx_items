window.DqxItems.Models.DictionaryItem = class DictionaryItem extends Backbone.Model

  idAttribute: "key"

  defaults:
    name: null
    kana: null
    type: null
    key:  null
    category: null

  initialize: ->
    @name = @get('name')
    @kana = @get('kana')
    @type = @get('type')
    @category = @get('category')

    throw new Error("name is required !") unless @name?

    @key  = DqxItems.Utils.CodeGenerator.generate("dictionaries") +
      DqxItems.Utils.CodeGenerator.generate(@get('name'))

  save: ->
    DqxItems.Utils.DataStorage.set(@key, @)

  destroy: ->
    DqxItems.Utils.DataStorage.destroy(@key)
    return @key



  @findByKey: (key) ->
    return new DqxItems.Models.DictionaryItem(DqxItems.Utils.DataStorage.get(key))

  @findByName: (item_name) ->
    _key = DqxItems.Models.DictionaryItem.dictionary_key +
      DqxItems.Utils.CodeGenerator.generate(item_name)
    return DqxItems.Models.DictionaryItem.findByKey(_key)

