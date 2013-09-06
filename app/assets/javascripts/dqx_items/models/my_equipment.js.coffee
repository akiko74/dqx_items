window.DqxItems.MyEquipment = class MyEquipment extends Backbone.Model
  defaults:
    name: null
    renkin_count: 0
    cost: 0
    kana: null
    key: null
    usage_count: 1

  initialize: (params) ->
    @set name: @get 'recipe_name' if @get 'recipe_name'
    dictionaryItem = (new DqxItems.DictionaryItemList()).where({name:@get('name')})[0]
    @set kana: dictionaryItem.get('kana') if dictionaryItem
    @set key: (DqxItems.MyItem.my_key()+ CryptoJS.SHA1(
      "#{@get('name')}+#{@get('renkin_count')}+#{@get('cost')}"
      ).toString()
    ) unless key?

  toParam: ->
    return {
      name: @get('name'),
      renkin_count: @get('renkin_count'),
      cost: @get('cost'),
      stock:0
    }

  destroy: ->
    param = @toParam()
    param.stock = -1
    DqxItems.MyItem.update_my_items([], [param])

  save: ->
    DqxItems.DataStorage.set(
      @get('key'),
      this
    )
