
window.DqxItems.MyItem = class MyItem

  @my_key = () ->
    return DqxItems.DataStorage.raw_get("my_key")

  constructor: (key) ->
    DqxItems.DataStorage.raw_set("my_key", key)


  debug_log = (method_name='',message) ->
    DqxItems.Logger.debug("[DqxItems.MyItem#{method_name}] ", message)

  @reload = (@force=true) ->
    if @force
      destroy_my_items()
      jQuery.ajax
        type:     "GET",
        url:      '/my/items.json',
        dataType: 'json',
        success:  MyItem.fetch_my_items_api_success
        error:    MyItem.fetch_my_items_api_error
        complete: MyItem.fetch_my_items_api_complete

  @fetch_my_items_api_success: (data) ->
    debug_log ".fetch_my_items_api_success()", data
    debug_log ".fetch_my_items_api_success()", "my_key: #{data.uid}"
    DqxItems.DataStorage.raw_set("my_key", data.uid)

    for item_data in data.equipments
      save_my_equipment item_data
    for item_data in data.items
      save_my_item item_data

    DqxItems.DataStorage.set(data.uid, data)
    table = new DqxItems.MyItemsTableBuilder()

  @fetch_my_items_api_error: ->
    console.log "/-- DqxItems.MyItem.fetch_my_items_api_error() --------------"
    console.log "--- DqxItems.MyItem.fetch_my_items_api_error() -------------/"

  @fetch_my_items_api_complete: ->
    console.log "/-- DqxItems.MyItem.fetch_my_items_api_complete() -----------"
    console.log "--- DqxItems.MyItem.fetch_my_items_api_complete() ----------/"

  destroy_my_items = () ->
    for row in DqxItems.DataStorage.keys()
      continue unless row.indexOf(MyItem.my_key()) == 0
      DqxItems.DataStorage.destroy(row)
      debug_log "#destroy_my_items()", "Destroied key: #{row}"

  save_my_item = (item_data) ->
    debug_log "#save_my_item()", item_data
    console.log (new DqxItems.MyItemInventory(item_data)).save()
    #debug_log "#save_my_item()", DqxItems.DataStorage.set(MyItem.my_key() + sha1.hex(item_data.name), item_data)

  save_my_equipment = (equipment_data) ->
    debug_log "#save_my_equipment()", equipment_data
    #debug_log "#save_my_equipment()", "#{equipment_data.name}+#{equipment_data.renkin_count}+#{equipment_data.cost}"
    #debug_log "#save_my_equipment()", DqxItems.DataStorage.set(MyItem.my_key() + sha1.hex("#{equipment_data.name}+#{equipment_data.renkin_count}+#{equipment_data.cost}"), equipment_data)
    console.log (new DqxItems.MyEquipment(equipment_data)).save()

  destroy_my_equipment = (equipment_data) ->
    debug_log "#destroy_my_equipment()", equipment_data
    debug_log "#destroy_my_equipment()", "#{equipment_data.name}+#{equipment_data.renkin_count}+#{equipment_data.cost}"
    _my_equipment_key = MyItem.my_key() + sha1.hex("#{equipment_data.name}+#{equipment_data.renkin_count}+#{equipment_data.cost}")
    debug_log "#destroy_my_equipment()", _my_equipment_key
    debug_log "#destroy_my_equipment()", DqxItems.DataStorage.get(_my_equipment_key)

    DqxItems.DataStorage.destroy(MyItem.my_key() + sha1.hex("#{equipment_data.name}+#{equipment_data.renkin_count}+#{equipment_data.cost}"))


  @get = (item_name) ->
    debug_log ".get()", "item_name: #{item_name}"
    _key = MyItem.my_key() + sha1.hex item_name
    debug_log ".get()", "key:       #{_key}"
    if DqxItems.DataStorage.raw_get _key
      _item = DqxItems.DataStorage.get _key
      debug_log ".get()", _item
      return _item
    else
      return null


  @update_my_items = (items=[], equipments=[]) ->
    debug_log ".update_my_items()", items
    jQuery.ajax
      type:     "POST",
      url:      '/my/items.json',
      data:     { _method:'PUT', items: items, equipments: equipments },
      dataType: 'json',
      success:  MyItem.update_my_items_api_success
      error:    MyItem.update_my_items_api_error
      complete: MyItem.update_my_items_api_complete

  @update_my_items_api_success: (data) ->
    debug_log ".update_my_items_api_success()", data
    DqxItems.MyItemsFormBuilder.clear()

    for item_data in data.equipments
      if (item_data.stock > 0)
        save_my_equipment item_data
      else
        destroy_my_equipment item_data

    for item_data in data.items
      save_my_item item_data if (item_data.stock > 0)

    new DqxItems.MyItemsTableBuilder()

  @update_my_items_api_error: ->

  @update_my_items_api_complete: ->
    DqxItems.MyItemsFormBuilder.show_form()




