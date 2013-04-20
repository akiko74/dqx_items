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
  @my_items_item_controlle_panel: "#item_controlle_panel"
  @my_items_renkin_count_inputs: "#renkin_count_inputs"
  @my_items_item_inputs: "#item_inputs"

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
    debug_log ".bind_functions()", "--- Start ---"
    bind_submit(@my_items_form_id)
    bind_calcurate(@my_items_calc_input_fields_class)
    bind_typeahead(@my_items_keyword_id)

    debug_log ".bind_functions()", DqxItems.Dictionary.all()
    debug_log ".bind_functions()", "--- End ---"


  bind_submit = (target) ->
    debug_log "#bind_submit()", "--- Start ---"
    jQuery(target)
      .bind "submit", submit_at_my_items_form
    debug_log "#bind_submit()", "Bind to #{target}"
    debug_log "#bind_submit()", "--- End ---"
    return true

  bind_calcurate = (target) ->
    debug_log "#bind_calcurate()", "--- Start ---"
    jQuery(target)
      .bind("keyup", calculate_at_my_items_form)
      .bind("change", calculate_at_my_items_form)
    debug_log "#bind_calcurate()", "Bind to #{target}"
    debug_log "#bind_calcurate()", "--- End ---"
    return true

  bind_typeahead = (target) ->
    debug_log "#bind_check()", "--- Start ---"
    jQuery(target).typeahead
      source:      typeahead_source,
      matcher:     typeahead_matcher,
      sorter:      typeahead_sorter,
      highlighter: typeahead_highlighter,
      updater:     typeahead_updater,
      items:       8

    debug_log "#bind_check()", "Bind to #{target}"
    debug_log "#bind_check()", "--- End ---"

  typeahead_source = (query, process) ->
    _source_data = jQuery.map DqxItems.Dictionary.all(), (item) ->
      item.name
    debug_log "#typeahead_source()", _source_data
    return _source_data

  typeahead_matcher = (item) ->
    if (DqxItems.Dictionary.get(item).kana.indexOf(this.query.trim()) == 0)
      debug_log "#typeahead_matcher()", "macth: #{item}"
      return true

  typeahead_sorter = (items) ->
    debug_log "#typeahead_sorter()", items
    item_list = []
    for item in items
      item_list.push DqxItems.Dictionary.get item
    item_list = item_list.sort (a,b) ->
      (a.kana < b.kana) ?  1 : -1
    debug_log "#typeahead_sorter()", item_list
    return items.sort()

  typeahead_highlighter = (item) ->
    regex = new RegExp( '(' + this.query + ')', 'gi' )
    item_str = item.replace( regex, "<strong>$1</strong>" )
    return item_str

  typeahead_updater = (item) ->
    _inputed = DqxItems.Dictionary.get(item)
    debug_log "#typeahead_updater()", _inputed
    switch _inputed.type
      when "item"
        jQuery(MyItemsFormBuilder.my_items_item_controlle_panel).show()
        jQuery(MyItemsFormBuilder.my_items_renkin_count_inputs).hide()
        jQuery("#del-button").attr("disabled", "disabled")
        jQuery("#add-button").attr("disabled", "disabled")
        jQuery(MyItemsFormBuilder.my_items_item_inputs).show()
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




  submit_at_my_items_form = (e) ->
    debug_log "#submit_at_my_items_form()", "--- Start ---"
    e.preventDefault()
    jQuery("#del-button").attr("disabled", "disabled")
    jQuery("#add-button").attr("disabled", "disabled")
    $('#item_controlle_panel .active').id()


    debug_log "#submit_at_my_items_form()", e
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


  enable_submits = (inputed_data = inputed()) ->
    debug_log "#enable_submits()", inputed_data
    switch DqxItems.Dictionary.get(inputed_data.keyword).type
      when 'item'
        if ( isFinite(inputed_data.stock) && isFinite(inputed_data.cost) && isFinite(inputed_data.total) && inputed_data.stock > 0 )
          $("#add-button").removeAttr("disabled")
        if ( isFinite(inputed_data.delete) && inputed_data.delete != 0 && typeof inputed_item()['my'] != "undefined")
          $("#del-button").removeAttr("disabled")
      when 'recipe'
        if ( isFinite(_input_renkin_total) )
          $("#add-button").removeAttr("disabled")
        if ( isFinite(_input_del_stock) && _input_del_stock != 0 && typeof inputed_item()['my'] != "undefined")
          $("#del-button").removeAttr("disabled")
      else
        debug_log "#enable_submits()", "inputed type unknown! #{DqxItems.Dictionary.get(inputed_data.keyword).type}"
    return true

  check_at_my_items_form = ->
    debug_log "#check_at_my_items_form()", "--- Start ---"
    debug_log "#check_at_my_items_form()", inputed().keyword
    debug_log "#check_at_my_items_form()", "--- End ---"
    return false



