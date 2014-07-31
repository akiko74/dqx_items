#my_items_form_builder.js.coffee
window.DqxItems.MyItemsFormBuilder = class MyItemsFormBuilder

  debug_log = (method_name='',message) ->
    DqxItems.Logger.debug("[DqxItems.MyItemsFormBuilder#{method_name}] ", message)

  @my_items_form_id: "#my_items_update_form"
  @my_items_calc_input_fields_class: "#{@my_items_form_id} .calc_input_fields"
  @my_items_keyword_id: "#{@my_items_form_id} input#keyword"
  @my_items_cost_id: "#{@my_items_form_id} input#cost"
  @my_items_stock_id: "#{@my_items_form_id} input#stock"
  @my_items_total_id: "#{@my_items_form_id} input#total"
  @my_items_del_stock_id: "#{@my_items_form_id} input#del_stock"
  @my_items_add_button_id: "#{@my_items_form_id} input#add-button"
  @my_items_del_button_id: "#{@my_items_form_id} input#del-button"
  @my_items_add_tab_id: "#{@my_items_form_id} #add_tab"
  @my_items_del_tab_id: "#{@my_items_form_id} #del_tab"
  @my_items_item_controlle_panel: "#item_controlle_panel"
  @my_items_renkin_count_inputs: "#renkin_count_inputs"
  @my_items_renkin_count: "#renkin_count"
  @my_items_renkin_total_cost: "#renkin_total"
  @my_items_item_inputs: "#item_inputs"
  @my_items_network_processing: "#network_processing"

  @clear = () ->
    jQuery(MyItemsFormBuilder.my_items_keyword_id).val("")
    jQuery(MyItemsFormBuilder.my_items_cost_id).val("")
    jQuery(MyItemsFormBuilder.my_items_stock_id).val("")
    jQuery(MyItemsFormBuilder.my_items_total_id).val("")
    jQuery(MyItemsFormBuilder.my_items_del_stock_id).val("")
    jQuery(MyItemsFormBuilder.my_items_renkin_count).val("")
    jQuery(MyItemsFormBuilder.my_items_renkin_total_cost).val("")
    jQuery("#del-button").attr("disabled", "disabled")
    jQuery("#add-button").attr("disabled", "disabled")

  buildFormData = () ->
    my_items_form_data = new DqxItems.MyItemsFormData(
      itemCost: parseInt(jQuery(MyItemsFormBuilder.my_items_cost_id).val()),
      itemStock: parseInt(jQuery(MyItemsFormBuilder.my_items_stock_id).val()),
      itemTotalCost: parseInt(jQuery(MyItemsFormBuilder.my_items_total_id).val()),
      keyword: jQuery(MyItemsFormBuilder.my_items_keyword_id).val(),
      deleteItemStock: parseInt(jQuery(MyItemsFormBuilder.my_items_del_stock_id).val()),
      renkinCount: parseInt(jQuery(MyItemsFormBuilder.my_items_renkin_count).val())
      renkinTotalCost: parseInt(jQuery(MyItemsFormBuilder.my_items_renkin_total_cost).val())
    )
    return my_items_form_data



  inputed = ->
    debug_log ".inputed()", "--- Start ---"

    debug_log ".inputed()", "Cost from #{MyItemsFormBuilder.my_items_cost_id}"
    _inputed_cost = parseInt(jQuery(MyItemsFormBuilder.my_items_cost_id).val())
    debug_log ".inputed()", _inputed_cost

    debug_log ".inputed()", "Stock from #{MyItemsFormBuilder.my_items_stock_id}"
    _inputed_stock = parseInt(jQuery(MyItemsFormBuilder.my_items_stock_id).val())
    debug_log ".inputed()", _inputed_stock

    debug_log ".inputed()", "Total Cost from #{MyItemsFormBuilder.my_items_total_id}"
    _inputed_total = parseInt(jQuery(MyItemsFormBuilder.my_items_total_id).val())
    debug_log ".inputed()", _inputed_total

    debug_log ".inputed()", "Delete Stock from #{MyItemsFormBuilder.my_items_del_stock_id}"
    _inputed_delete = parseInt(jQuery(MyItemsFormBuilder.my_items_del_stock_id).val())
    debug_log ".inputed()", _inputed_delete

    debug_log ".inputed()", "Keyword from #{MyItemsFormBuilder.my_items_keyword_id}"
    _inputed_keyword = jQuery(MyItemsFormBuilder.my_items_keyword_id).val()
    debug_log ".inputed()", _inputed_keyword

    #debug_log ".inputed()",

    debug_log ".inputed()", "--- End ---"
    return { cost: _inputed_cost, stock: _inputed_stock, total: _inputed_total, delete: _inputed_delete, keyword:_inputed_keyword  }

  @bind_functions = () ->
    bind_submit(@my_items_form_id)
    bind_calcurate(@my_items_calc_input_fields_class)
    bind_typeahead(@my_items_keyword_id)
    bind_add_action(@my_items_add_button_id)
    bind_del_action(@my_items_del_button_id)



  bind_add_action = (target) ->
    jQuery(target).bind "click", add_my_item

  bind_del_action = (target) ->
    jQuery(target).bind "click", del_my_item

  bind_submit = (target) ->
    jQuery(target)
      .bind "submit", submit_at_my_items_form
    debug_log "#bind_submit()", "Bind to #{target}"
    return true

  bind_calcurate = (target) ->
    jQuery(target)
      .bind("keyup", calculate_at_my_items_form)
      .bind("change", calculate_at_my_items_form)
    debug_log "#bind_calcurate()", "Bind to #{target}"
    return true

  bind_typeahead = (target) ->
    jQuery(target).typeahead
      source:      typeahead_source,
      matcher:     typeahead_matcher,
      sorter:      typeahead_sorter,
      highlighter: typeahead_highlighter,
      updater:     typeahead_updater,
      items:       8

    debug_log "#bind_check()", "Bind to #{target}"

  typeahead_source = (query, process) ->
    return (new DqxItems.Collections.DictionaryItemList()).pluck("name")

  typeahead_matcher = (item) ->
    _query = this.query.trim()
    return false if _query.length < 3
    target_item = (new DqxItems.Collections.DictionaryItemList()).where({name:item})[0]
    if ((target_item.get('kana')? ) && (target_item.get('kana').indexOf(_query) == 0))
      debug_log "#typeahead_matcher()", "macth:  #{item} (#{target_item.get('kana')})"
      return true

  typeahead_sorter = (items) ->
    return [] if items.length < 1
    debug_log "typeahead_sorter()", 'before: ["' + items.join('", "') + '"]'
    item_list = []
    for item in items
      item_list.push (new DqxItems.Collections.DictionaryItemList()).where({name:item})[0]
    item_list = item_list.sort (a,b) ->
      return -1 if (a.get('kana') < b.get('kana'))
      return 1 if (a.get('kana') > b.get('kana'))
      return 0
    _data = jQuery.map item_list, (item) ->
      item.get('name')
    debug_log "#typeahead_sorter()", 'after: ["' + _data.join('", "') + '"]'
    return _data

  typeahead_highlighter = (item) ->
    regex = new RegExp( '(' + this.query + ')', 'gi' )
    item_str = item.replace( regex, "<strong>$1</strong>" )
    return item_str

  typeahead_updater = (item) ->
    _inputed = (new DqxItems.Collections.DictionaryItemList()).where({name:item})[0]
    _mine = DqxItems.MyItem.get(item)
    debug_log "#typeahead_updater()", _inputed
    debug_log "#typeahead_updater()", _mine
    if _mine
      jQuery(MyItemsFormBuilder.my_items_del_tab_id).show()
    else
      jQuery(MyItemsFormBuilder.my_items_del_tab_id).hide()
    switch _inputed.get('type')
      when "item"
        MyItemsFormBuilder.init_my_item_inventory_controll_panel()
      when "recipe"
        jQuery(MyItemsFormBuilder.my_items_item_controlle_panel).show()
        jQuery("#del-button").attr("disabled", "disabled")
        jQuery("#add-button").attr("disabled", "disabled")
        jQuery(MyItemsFormBuilder.my_items_renkin_count_inputs).show()
        jQuery(MyItemsFormBuilder.my_items_item_inputs).hide()
      else
        jQuery(MyItemsFormBuilder.my_items_item_controlle_panel).hide()
        debug_log "unknown type."
    return item

  @init_my_item_inventory_controll_panel = () ->
    jQuery(MyItemsFormBuilder.my_items_item_controlle_panel).show()
    jQuery(MyItemsFormBuilder.my_items_renkin_count_inputs).hide()
    jQuery("#del-button").attr("disabled", "disabled")
    jQuery("#add-button").attr("disabled", "disabled")
    jQuery(MyItemsFormBuilder.my_items_item_inputs).show()


  add_my_item = (e) ->
    debug_log "#add_my_item()", e
    e.preventDefault()
    MyItemsFormBuilder.hidden_form()
    req = { equipments: [], items: [] }
    form_data = buildFormData()
    switch form_data.dictionary().get('type')
      when 'item'
        req.items.push form_data.toAddItemParam()
      when 'recipe'
        req.equipments.push form_data.toAddEquipmentParam()
      else
        debug_log "#add_my_item()", form_data.dictionary().get('type')
    debug_log "#add_my_item()", req
    DqxItems.MyItem.update_my_items(req.items, req.equipments)

  del_my_item = (e) ->
    debug_log "#del_my_item()", e
    e.preventDefault()
    MyItemsFormBuilder.add_button_disable()
    MyItemsFormBuilder.delete_button_disable()
    req = { equipments: [], items: [] }
    form_data = buildFormData()
    switch form_data.dictionary().get('type')
      when 'item'
        req.items.push form_data.toDeleteItemParam()
      when 'recipe'
        req.equipments.push form_data.toDeleteEquipmentParam()
      else
        debug_log "#del_my_item()", form_data.dictionary().get('type')
    debug_log "#del_my_item()", req
    DqxItems.MyItem.update_my_items(req.items, req.equipments)


  @hidden_form = () ->
    jQuery(MyItemsFormBuilder.my_items_network_processing)
      .css('height', jQuery(MyItemsFormBuilder.my_items_form_id).css("height"))
    jQuery(MyItemsFormBuilder.my_items_network_processing).show()
    jQuery(MyItemsFormBuilder.my_items_form_id).hide()

  @show_form = () ->
    jQuery(MyItemsFormBuilder.my_items_network_processing).hide()
    jQuery(MyItemsFormBuilder.my_items_form_id).show()


  submit_at_my_items_form = (e) ->
    debug_log "#submit_at_my_items_form()", "--- Start ---"
    debug_log "#submit_at_my_items_form()", e
    e.preventDefault()
    MyItemsFormBuilder.add_button_disable()
    MyItemsFormBuilder.delete_button_disable()
    req = { equipments: [], items: [] }
    debug_log "#submit_at_my_items_form()", jQuery(".tab-pane.active > table").attr("id")
    switch jQuery(".tab-pane.active > table").attr("id")
      when "item_inputs"
        req.items.push "aaa"
      when "renkin_count_inputs"
      else
        debug_log "#submit_at_my_items_form()", jQuery(".tab-pane.active > table").attr("id")
    debug_log "#submit_at_my_items_form()", req
    DqxItems.MyItem.update_my_items(req.items, req.equipments)
#$('#item_controlle_panel .active').id()

    debug_log "#submit_at_my_items_form()", "--- End ---"
    return false

  calculate_at_my_items_form = (e) ->
    _inputed = inputed()
    if ( isFinite(_inputed.cost) && _inputed.cost < 0 )
      debug_log "#calculate_at_my_items_form()", "Adjust Cost to 0"
      _inputed.cost = 0
    if ( isFinite(_inputed.stock) && _inputed.stock < 0 )
      debug_log "#calculate_at_my_items_form()", "Adjust Stock to 0"
      _inputed.stock = 0
    if ( isFinite(_inputed.total) && _inputed.total < 0 )
      debug_log "#calculate_at_my_items_form()", "Adjust Total to 0"
      _inputed.total = 0

    switch jQuery(e.target)[0].id
      when "stock"
        debug_log "#calculate_at_my_items_form()", "Change Stock to #{_inputed.stock}"
        if ( isFinite(_inputed.stock) && isFinite(_inputed.cost) && _inputed.cost )
          _inputed.total = _inputed.stock * _inputed.cost
          debug_log "#calculate_at_my_items_form()", "Calculate Total to #{_inputed.total}"
        else if ( isFinite(_inputed.stock) && isFinite(_inputed.total) && _inputed.total > 0)
          _inputed.cost  = parseInt(_inputed.total / _inputed.stock + 0.5)
          debug_log "#calculate_at_my_items_form()", "Calculate Cost to #{_inputed.cost}"
      when "cost"
        debug_log "#calculate_at_my_items_form()", "Change Cost to #{_inputed.cost}"
        if ( isFinite(_inputed.stock) && isFinite(_inputed.cost) )
          _inputed.total = _inputed.cost * _inputed.stock
          debug_log "#calculate_at_my_items_form()", "Calculate Total to #{_inputed.total}"
      when "total"
        debug_log "#calculate_at_my_items_form()", "Change Total to #{_inputed.total}"
        if ( isFinite(_inputed.stock) && isFinite(_inputed.total) )
          _inputed.cost = parseInt(_inputed.total / _inputed.stock + 0.5)
          debug_log "#calculate_at_my_items_form()", "Calculate Cost to #{_inputed.cost}"
      else
        debug_log "#calculate_at_my_items_form()", "Invaid ID: #{jQuery(e.target)[0].id}"

    debug_log "#calculate_at_my_items_form()", _inputed

    jQuery(MyItemsFormBuilder.my_items_cost_id).val(_inputed.cost) if isFinite(_inputed.cost)
    jQuery(MyItemsFormBuilder.my_items_stock_id).val(_inputed.stock) if isFinite(_inputed.stock)
    jQuery(MyItemsFormBuilder.my_items_total_id).val(_inputed.total) if isFinite(_inputed.total)
    jQuery(MyItemsFormBuilder.my_items_del_stock_id).val(_inputed.delete) if isFinite(_inputed.delete)

    enable_submits()
    return false


  enable_submits = (form_data = buildFormData()) ->
    debug_log "#enable_submits()", form_data
    debug_log "#enable_submits()", form_data.dictionary()
    MyItemsFormBuilder.add_button_disable()
    MyItemsFormBuilder.delete_button_disable()
    return false unless form_data.dictionary()?
    switch form_data.dictionary().get('type')
      when 'item'
        MyItemsFormBuilder.add_button_enable() if form_data.checkItemAddable()
        MyItemsFormBuilder.delete_button_enable() if form_data.checkItemDeletable()
      when 'recipe'
        MyItemsFormBuilder.add_button_enable() if form_data.checkRenkinAddable()
        MyItemsFormBuilder.delete_button_enable() if form_data.checkRenkinDeletable()
      else
        debug_log "#enable_submits()", "inputed type unknown! #{form_data.dictionary().get('type')}"
    return true

  @add_button_enable = () ->
    jQuery("#add-button").removeAttr("disabled")

  @add_button_disable = () ->
    jQuery("#add-button").attr("disabled", "disabled")

  @delete_button_enable = () ->
    jQuery("#del-button").removeAttr("disabled")

  @delete_button_disable = () ->
    jQuery("#del-button").attr("disabled", "disabled")

  check_at_my_items_form = ->
    debug_log "#check_at_my_items_form()", "--- Start ---"
    debug_log "#check_at_my_items_form()", inputed().keyword
    debug_log "#check_at_my_items_form()", "--- End ---"
    return false


