window.DqxItems.MyItemsTableBuilder = class MyItemsTableBuilder

  debug_log = (method_name='',message) ->
    DqxItems.Logger.debug(
      "[DqxItems.MyItemsTableBuilder#{method_name}] ",
      message)

  @equipment_destroy_buttons: ".equipment_destroy_button"

  constructor: () ->

    @my_items = DqxItems.MyItemList.instance
    #@my_items = new DqxItems.MyItemList()
    #@my_items.fetchFromStorage()
    (new DqxItems.MyEquipmentsTable({collection:@my_items.equipments})).render()
    (new DqxItems.MyItemInventoryTable({collection:@my_items.items})).render()


#    DqxItems.MyItemsTableBuilder.bind_functions()



  @bind_functions = () ->
    bind_equipment_destroy(@equipment_destroy_buttons)

  bind_equipment_destroy = (target) ->
    jQuery(target)
      .bind "click", destroy_my_equipment
    debug_log "#bind_equipment_destroy()", "Bind to #{target}"
    return true


  destroy_my_equipment = (e) ->
    row          = equipment_destroy_button2row(e.target)
    equipment    = row2equipment(row)
    DqxItems.MyItem.update_my_items([],[equipment])



  equipment_destroy_button2row = (element) ->
    jQuery(element).parent().parent()


  row2equipment = (row) ->
    {
      name: row.find(".name").text().split(/\s+/)[0],
      stock: -1,
      renkin_count: parseInt(row.find(".renkin_count").text().match(/[0-9]+/)[0], 10),
      cost: parseInt(row.find(".cost").text().split(/G/)[0], 10)
    }


