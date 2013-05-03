
window.DqxItems.MyItem = class MyItem

  @my_key = () ->
    return DqxItems.DataStorage.raw_get("my_key")

  constructor: (key) ->
    DqxItems.DataStorage.raw_set("my_key", key)


  debug_log = (method_name='',message) ->
    DqxItems.Logger.debug("[DqxItems.MyItem#{method_name}] ", message)

  @reload = (@force=true) ->
    debug_log ".reload()", "--- start ------------------------------------"
    if @force
      destroy_my_items()
      jQuery.ajax
        type:     "GET",
        url:      '/my/items.json',
        dataType: 'json',
        success:  MyItem.fetch_my_items_api_success
        error:    MyItem.fetch_my_items_api_error
        complete: MyItem.fetch_my_items_api_complete
    debug_log ".reload()", "--- end --------------------------------------"

  @fetch_my_items_api_success: (data) ->
    debug_log ".fetch_my_items_api_success()", data
    DqxItems.DataStorage.raw_set("my_key", data.uid)

    for item_data in data.equipments
      save_my_item item_data
    for item_data in data.items
      save_my_item item_data

  @fetch_my_items_api_error: ->
    console.log "/-- DqxItems.MyItem.fetch_my_items_api_error() --------------"
    console.log "--- DqxItems.MyItem.fetch_my_items_api_error() -------------/"

  @fetch_my_items_api_complete: ->
    console.log "/-- DqxItems.MyItem.fetch_my_items_api_complete() -----------"
    console.log "--- DqxItems.MyItem.fetch_my_items_api_complete() ----------/"

  destroy_my_items = () ->
    debug_log "#destroy_my_items()", "--- Start ---"
    for row in DqxItems.DataStorage.keys()
      continue unless row.indexOf(MyItem.my_key()) == 0
      DqxItems.DataStorage.destroy(row)
      debug_log "#destroy_my_items()", row
    debug_log "#destroy_my_items()", "--- End ---"

  save_my_item = (item_data) ->
    debug_log "#save_my_item()", item_data
    debug_log "#save_my_item()", DqxItems.DataStorage.set(MyItem.my_key() + sha1.hex(item_data.name), item_data)

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
    debug_log "update_my_items_api_success()", data
    DqxItems.MyItemsFormBuilder.clear()
    for item_data in data.equipments
      save_my_item item_data
    for item_data in data.items
      save_my_item item_data

  @update_my_items_api_error: ->

  @update_my_items_api_complete: ->
    DqxItems.MyItemsFormBuilder.show_form()


