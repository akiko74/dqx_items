window.DqxItems.MyItemInventory = class MyItemInventory extends Backbone.Model
  defaults:
    name: null
    stock: 0
    cost: 0
    kana: null
    key: null

  initialize: (params) ->
    dictionaryItem = (new DqxItems.Collections.DictionaryItemList()).where({name:@get('name')})[0]
    @set kana: dictionaryItem.get('kana') if dictionaryItem
    @set key: (DqxItems.MyItem.my_key() + CryptoJS.SHA1(@get('name')).toString()) unless key?
    @set cost: (@get('total_cost') / @get('stock')) if @get('total_cost')?


  save: ->
    DqxItems.Utils.DataStorage.set(
      @get('key'),
      this
    )

