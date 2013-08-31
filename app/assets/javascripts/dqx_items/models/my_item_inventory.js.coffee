window.DqxItems.MyItemInventory = class MyItemInventory extends Backbone.Model
  defaults:
    name: null
    stock: 0
    cost: 0
    kana: null
    key: null

  initialize: (params) ->
    dictionaryItem = (new DqxItems.DictionaryItemList()).where({name:@get('name')})[0]
    @set kana: dictionaryItem.get('kana') if dictionaryItem
    @set key: (DqxItems.MyItem.my_key() + sha1.hex(@get 'name')) unless key?
    @set cost: (@get('total_cost') / @get('stock')) if @get('total_cost')?


  save: ->
    DqxItems.DataStorage.set(
      @get('key'),
      this
    )

