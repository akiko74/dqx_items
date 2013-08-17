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
    @set kana: DqxItems.Dictionary.get(@get 'name').kana
    @set key: (DqxItems.MyItem.my_key()+ sha1.hex(
      "#{@get('name')}+#{@get('renkin_count')}+#{@get('cost')}"
    )) unless key?

  to_param: ->
    return {
      name: @get('name'),
      renkin_count: @get('renkin_count'),
      cost: @get('cost'),
      stock:0
    }

  destroy: ->
    param = @to_param()
    param.stock = -1
    DqxItems.MyItem.update_my_items([], [param])
    console.log param

  save: ->
    DqxItems.DataStorage.set(
      @get('key'),
      this
    )
