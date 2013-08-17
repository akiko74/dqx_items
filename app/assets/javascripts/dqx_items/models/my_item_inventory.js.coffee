window.DqxItems.MyItemInventory = class MyItemInventory extends Backbone.Model
  defaults:
    name: null
    stock: 0
    cost: 0
    kana: null
    key: null

  initialize: (params) ->
    @set kana: DqxItems.Dictionary.get(@get 'name').kana
    @set key: (DqxItems.MyItem.my_key() + sha1.hex(@get 'name')) unless key?

  save: ->
    DqxItems.DataStorage.set(
      @get('key'),
      this
    )

