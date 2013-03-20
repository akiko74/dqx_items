window.Application ||= {}

debug = true
map = {};
uid = '';

jQuery ->
  bootstrap();


bootstrap = () ->
  console.log "bootstrap" if debug
  fetch_dictionaries();
  bind_functions();
  fetch_my_items();
  console.log "bootstraped" if debug


fetch_dictionaries = () ->
  $.ajax({
    type: "GET",
    url: '/dictionaries.json',
    dataType: 'json',
    success: (data) ->
      console.log "Request to /dictionaries.json is success." if debug;
      localStorage['dictionaries'] = JSON.stringify(data)
      if debug
        console.log "--- Dictionary data -----------------------------------------------------"
        console.log localStorage['dictionaries']
        console.log "-------------------------------------------------------------------------"
    error: ->
      console.log "[ERROR] Request to /dictionaries.json is failed!";
  });


updte_my_item_data = (submit_data) ->
  console.log '-----------';
  console.log submit_data;
  console.log '-----------';
  items = [submit_data];
  equipments = [submit_data];
  $("#del-button").attr("disabled", "disabled");
  $("#add-button").attr("disabled", "disabled");
  $("#my_items_update_form").hide();
  $("#network_processing").show();
  $.ajax({
    type: "POST",
    url: '/my/items.json',
    data: { _method:'PUT', items: items, equipments: equipments },
    dataType: 'json',
    success: (msg) ->
      if debug
        console.log "Data Saved: "
        console.log msg

      for item in msg.items
        if debug
          console.log get_my_item_by_name(item.name);
          console.log item;
        _item = set_and_get_my_item(item);
        add_my_item_list(_item);

      for equipment in msg.equipments
        if debug
          console.log get_my_equipment_by_name(equipment.name);
          console.log equipment;
        _equipment = set_and_get_my_equipment(equipment);
        add_my_equipment_list(_equipment);

      reload_my_items_tabs(get_my_item_list_with_data(), get_my_equipment_list_with_data());
      $("#my_items_update_form input#cost, #my_items_update_form input#stock, #my_items_update_form input#total, #my_items_update_form input#del_stock, #my_items_update_form input#keyword").val('');
      $("#my_items_update_form input#keyword").focus();
    error: ->
      $("#del-button").removeAttr("disabled");
      $("#add-button").removeAttr("disabled");
    complete: ->
      console.log "Complete Request."
      $("#network_processing").hide();
      $("#my_items_update_form").show();

        
#      console.log get_my_item_by_name(submit_data.name);



  });

bind_functions = () ->
  console.log "Set typeahead to #my_items_update_form input#keyword"

  $("#my_items_update_form").bind "submit", (e) ->
    e.preventDefault();
    return false;

  $("#my_items_update_form #total, #my_items_update_form #cost, #my_items_update_form #stock, #my_items_update_form #del_stock")
     .bind("keyup", calc_inputs)
     .bind("change", calc_inputs)
  $("#my_items_update_form input#keyword")
     .bind("keyup", check_keyword)
     .bind("change", check_keyword)

  $("#add-button").bind "click", ->
    console.log "Add Item !"
    submit_data = { name: "", cost: 0, stock: 0 };
    _input_cost  = parseInt($("#my_items_update_form input#total").val())
    _input_stock = parseInt($("#my_items_update_form input#stock").val())
    submit_data.name   = $("#my_items_update_form input#keyword").val();
    submit_data.cost  += _input_cost if isFinite(_input_cost); 
    submit_data.stock += _input_stock if isFinite(_input_stock); 
    console.log '-----------';
    console.log submit_data;
    console.log '-----------';
    return updte_my_item_data(submit_data);

  $("#del-button").bind "click", ->
    console.log "Del Item !"
    submit_data = { name: "", cost: 0, stock: 0 };
    _input_stock  = parseInt($("#my_items_update_form input#del_stock").val())
    submit_data.name   = $("#my_items_update_form input#keyword").val();
    submit_data.stock += _input_stock if isFinite(_input_stock);
    submit_data.stock *= -1 if submit_data.stock > 0
    submit_data.cost  += get_my_item_by_name(submit_data.name).cost * submit_data.stock;
    return updte_my_item_data(submit_data);

  $("#my_items_update_form input#keyword").typeahead({

    source: (query, process) ->
      JSON.parse(localStorage['dictionaries'])
      states = [];
      data = JSON.parse(localStorage['dictionaries']);
      $.each data, (i, item) ->
        map[item.name] = item;
        states.push(item.name);
      console.log states;
      return states;

    matcher: (item) ->
      #if (item.toLowerCase().indexOf(this.query.trim().toLowerCase()) != -1) 
      if (item.toLowerCase().indexOf(this.query.trim().toLowerCase()) == 0) 
        console.log "match!: " + item;
        return true;

    sorter: (items) ->
      return items.sort();

    highlighter: (item) ->
      regex = new RegExp( '(' + this.query + ')', 'gi' );
      item_str = item.replace( regex, "<strong>$1</strong>" );
      return item_str;

    updater: (item) ->
      console.log "updater";
      if map[item].type == "recipe"
        #get_keyword_tag().removeClass("span12").addClass("span9");
        $("#renkin_count_inputs").show();
      else
        #get_keyword_tag().removeClass("span9").addClass("span12");
        $("#renkin_count_inputs").hide();
      console.log JSON.stringify(map[item]);
      console.log "updater";
      return item;

    items: 8;
  });

  console.log "Set typeahead."
  $("#del-button").attr("disabled", "disabled");
  $("#add-button").attr("disabled", "disabled");


get_keyword_tag = (selector = "#my_items_update_form input#keyword") ->
  return $(selector);

calc_inputs = (e) ->
  if debug
    console.log "calc inputs."
  _input_cost  = parseInt($("#my_items_update_form input#cost").val())
  _input_stock = parseInt($("#my_items_update_form input#stock").val())
  _input_total = parseInt($("#my_items_update_form input#total").val())
  _input_del_stock = parseInt($("#my_items_update_form input#del_stock").val())
  if debug
    console.log "cost: #{_input_cost}";
    console.log "stock: #{_input_stock}";
    console.log "total: #{_input_total}";
    console.log "del_stock: #{_input_del_stock}";
  if ( isFinite(_input_cost) && _input_cost < 0 )
    _input_cost = 0
    $("#my_items_update_form input#cost").val(0);
  if ( isFinite(_input_stock) && _input_stock < 0 )
    _input_stock = 0
    $("#my_items_update_form input#stock").val(0);
  if ( isFinite(_input_total) && _input_total < 0 )
    _input_total = 0
    $("#my_items_update_form input#total").val(0);

  if $(e.target)[0].id == "stock"
    if ( isFinite(_input_stock) && isFinite(_input_cost) && _input_cost > 0 )
      $("#my_items_update_form input#total").val(_input_stock * _input_cost);
    else if ( isFinite(_input_stock) && isFinite(_input_total) && _input_total > 0)
      $("#my_items_update_form input#cost").val(parseInt(_input_total / _input_stock));
  else if $(e.target)[0].id == "cost"
    if ( isFinite(_input_stock) && isFinite(_input_cost) )
      $("#my_items_update_form input#total").val(_input_stock * _input_cost);
  else if $(e.target)[0].id == "total"
    if ( isFinite(_input_stock) && isFinite(_input_total) )
      $("#my_items_update_form input#cost").val(parseInt(_input_total / _input_stock));
  check_inputs();

check_inputs = () ->
  _input_keyword = $("#my_items_update_form input#keyword").val()
  _input_cost  = parseInt($("#my_items_update_form input#cost").val())
  _input_stock = parseInt($("#my_items_update_form input#stock").val())
  _input_total = parseInt($("#my_items_update_form input#total").val())
  _input_del_stock = parseInt($("#my_items_update_form input#del_stock").val())
  if ( isFinite(_input_stock) && isFinite(_input_cost) && isFinite(_input_total) && _input_keyword && _input_stock > 0 && typeof map[_input_keyword] != "undefined")
    $("#add-button").removeAttr("disabled");
  else
    $("#add-button").attr("disabled", "disabled");

  if ( isFinite(_input_del_stock) && _input_keyword && _input_del_stock != 0 && typeof map[_input_keyword] != "undefined" && typeof localStorage[uid + sha1.hex(_input_keyword)] != "undefined")
    $("#del-button").removeAttr("disabled");
  else
    $("#del-button").attr("disabled", "disabled");
 

check_keyword = () ->
  _input_keyword = $("#my_items_update_form input#keyword").val()
  keyword_key = uid + sha1.hex(_input_keyword);
  console.log "keyword_key: #{keyword_key}" if debug
  if (typeof localStorage[keyword_key] != "undefined")
    if debug
      console.log "LocalStorage matched!!"
      console.log localStorage[keyword_key]
    #reload_my_items_tabs([], [ JSON.parse(localStorage[keyword_key]) ])
  check_inputs();


fetch_my_items = () ->
  $.getJSON '/my/items.json', (data, status) ->
    if debug
      console.log "Ajax Request => #{status}"
      console.log "--- My Items and Equipments Data ----------------------------------------"
      console.log JSON.stringify(data)
      console.log "-------------------------------------------------------------------------"
      console.log "--- localStorage keys ---------------------------------------------------"
      for key of localStorage
        console.log key
      console.log "-------------------------------------------------------------------------"

    uid = data['uid']
    console.log "uid = #{uid}" if debug

    for equipment in data['equipments']
      _equipment = set_and_get_my_equipment(equipment);
      add_my_equipment_list(_equipment);

    for item in data['items']
      _item = set_and_get_my_item(item);
      add_my_item_list(_item);

    if debug
      console.log "MyEquipmentList:";
      console.log get_my_equipment_list_with_data();
      console.log "MyItemList:";
      console.log get_my_item_list_with_data();
      console.log "";

    reload_my_items_tabs(get_my_item_list_with_data(), get_my_equipment_list_with_data());


my_equipment_key = (equipment_name) ->
  return uid + sha1.hex(equipment_name);

get_my_equipment_by_name = (equipment_name) ->
  return get_my_equipment_by_key(my_equipment_key(equipment_name));

get_my_equipment_by_key = (equipment_key) ->
  _equipment = localStorage[equipment_key];
  if typeof _equipment != "undefined"
    return JSON.parse(_equipment);
  return { name: equipment_name, cost: 0, stock: 0, renkin_count: 0 };

set_my_equipment = (equipment) ->
  if debug
    console.log "set_my_equipment()"
    console.log "key: #{my_equipment_key(equipment.name)}"
    console.log equipment;
  localStorage[my_equipment_key(equipment.name)] = JSON.stringify(equipment);

set_and_get_my_equipment = (equipment) ->
  set_my_equipment(equipment);
  return get_my_equipment_by_name(equipment.name);


my_equipment_list_key = () ->
  return uid + sha1.hex('equipments');

set_and_get_my_equipment_list = (my_equipment_list) ->
  set_my_equipment_list(my_equipment_list);
  return get_my_equipment_list();

set_my_equipment_list = (my_equipment_list) ->
  localStorage[my_equipment_list_key()] = JSON.stringify(my_equipment_list);

get_my_equipment_list = () ->
  return JSON.parse(localStorage[my_equipment_list_key()] || "[]")
  
add_my_equipment_list = (equipment) ->
  _my_equipment_list = get_my_equipment_list();
  _my_equipment_list.push(my_equipment_key(equipment.name));
  _my_equipment_list = jQuery.unique(_my_equipment_list);
  set_my_equipment_list(_my_equipment_list);

add_and_get_my_equipment_list = (equipment) ->
  add_my_equipment_list(equipment);
  return get_my_equipment_list();


get_my_equipment_list_with_data = () ->
  _my_equipment_list_data = [];
  for _equipment_key in get_my_equipment_list()
    _my_equipment_list_data.push JSON.parse(localStorage[_equipment_key]);
  return _my_equipment_list_data;
 


my_item_key = (item_name) ->
  return uid + sha1.hex(item_name); 

set_and_get_my_item = (item) ->
  set_my_item(item);
  return get_my_item_by_name(item.name);

set_my_item = (item) ->
  if debug
    console.log "set_my_item()"
    console.log "key: #{my_item_key(item.name)}"
    console.log item;
  localStorage[my_item_key(item.name)] = JSON.stringify(item);

get_my_item_by_name = (item_name) ->
  item_key = my_item_key(item_name);
  _item = localStorage[item_key];
  if typeof _item != "undefined"
    return JSON.parse(_item);
  return { name: item_name, cost: 0, stock: 0 };


my_item_list_key = () ->
  return uid + sha1.hex('items');

set_and_get_my_item_list = (my_item_list) ->
  set_my_item_list(my_item_list);
  return get_my_item_list();

set_my_item_list = (my_item_list) ->
  localStorage[my_item_list_key()] = JSON.stringify(my_item_list);

get_my_item_list = () ->
  return JSON.parse(localStorage[my_item_list_key()] || "[]")
  
add_my_item_list = (item) ->
  _my_item_list = get_my_item_list();
  _my_item_list.push(my_item_key(item.name));
  _my_item_list = jQuery.unique(_my_item_list);
  set_my_item_list(_my_item_list);

add_and_get_my_item_list = (item) ->
  add_my_item_list(item);
  return get_my_item_list();


get_my_item_list_with_data = () ->
  console.log "get_my_item_list_with_data() - - - - -" if debug;
  _my_item_list_data = new Array();
  for _item_key in get_my_item_list()
    _my_item_list_data.push JSON.parse(localStorage[_item_key]);
  console.log _my_item_list_data if debug;
  console.log "- - - - - - - - - - - - - - - - - - - -" if debug
  return _my_item_list_data;
 

reload_my_items_tabs = (items, equipments) ->

  console.log "Reload My Items tabs."
  $("#users_item_list #my_item_list tbody").html('');
  for num of items
    item = items[num];
    console.log item;
    $("#users_item_list #my_item_list tbody").append("<tr><td>#{item.name}</td><td>#{item.stock}</td><td>#{item.cost}</td></tr>");
    console.log "Append row  - - - - - - - -"
    console.log item;
    console.log "- - - - - - - - - - - - - -"

  console.log "Reload My Equipments tabs."
  $("#users_item_listi #my_equipment_list tbody").html();
  for equipment of equipments
    console.log equipment
    $("#users_item_listi #my_equipment_list tbody").append("<tr><td>#{equipment.name}</td><td>#{equipment.stock}</td><td>#{equipment.cost}</td></tr>");




update_all = (hash) ->
  console.log hash


###

Application.display_stock_console = (type,character_item_id) ->
  if $('#' + character_item_id + " ." + type + "_consoles").css("display") == "none"
    $(".plus").removeClass("btn-inverse")
    $(".add_consoles, .del_consoles").hide()
    $(".minus").removeClass("btn-inverse")
    $('#' + character_item_id + " ." + type + "_consoles").show()
    if type == "add"
      $('#' + character_item_id + " .plus").addClass("btn-inverse")
    else
      $('#' + character_item_id + " .minus").addClass("btn-inverse")
  else
    $('#' + character_item_id + " ." + type + "_consoles").hide();
    if type == "add"
      $('#' + character_item_id + " .plus").removeClass("btn-inverse")
    else
      $('#' + character_item_id + " .minus").removeClass("btn-inverse")
  return false


Application.add_calc = (tag_id, character_item_key) ->
  request_param = {}
  if debug
    console.log "add_calc(#{tag_id}, #{character_item_key})"
    console.log localStorage[character_item_key]
    console.log $("##{tag_id} .add_consoles .add_stock input").val()
  character_item = JSON.parse(localStorage[character_item_key])
  request_param['character_id'] = character_item['character_id']
  request_param['item_id']      = character_item['id']
  request_param['stock']        = parseInt($("##{tag_id} .add_consoles .add_stock input").val())
  request_param['total_cost']   = parseInt($("##{tag_id} .add_consoles .add_cost input").val())
  modify_character_item_stocks([request_param])
  return false


Application.del_calc = (tag_id, character_item_key) ->
  request_param = {}
  if debug
    console.log "del_calc(#{tag_id}, #{character_item_key})"
    console.log localStorage[character_item_key]
    console.log $("##{tag_id} .del_consoles .del_stock input").val()
  character_item = JSON.parse(localStorage[character_item_key])
  request_param['character_id'] = character_item['character_id']
  request_param['item_id']      = character_item['id']
  request_param['stock']        = parseInt($("##{tag_id} .del_consoles .del_stock input").val())
  request_param['stock'] = request_param['stock'] * 1 if request_param['stock'] > 0
  modify_character_item_stocks([request_param])
  return false


modify_character_item_stocks = (param) ->
  console.log param
  $.ajax({
    type: "POST",
    url: '/my/items',
    data: { _method:'PUT', character_items_stocks: param },
    dataType: 'json',
    success: (msg) ->
      console.log "Data Saved: " + msg
  })


renew_my_items_data = () ->
  console.log "renew my items data" if debug
  $.getJSON '/my/items.json', (data, status) ->
    if debug
      console.log "Ajax Request => #{status}"
      console.log "--- data ----------------------------------------------------------------"
      console.log JSON.stringify(data)
      console.log "-------------------------------------------------------------------------"
    localStorage.clear()
    if debug
      console.log "--- localStorage keys ---------------------------------------------------"
      for key of localStorage
        console.log key
      console.log "-------------------------------------------------------------------------"
  
tmp = () ->
    characters_items_hash = {}
    characters_items_hash[sha1.hex("characters-0-items")] = []
    character_key_list = []
    for character in data['characters']
      character_key = sha1.hex "characters-#{character['id']}"
      localStorage[character_key] = JSON.stringify(character)
      if debug
        console.log "--- #{character_key} (characters-#{character['id']}) -------------"
        console.log localStorage[character_key]
        console.log "-------------------------------------------------------------------------"
      character_key_list.push character_key
      characters_items_hash[sha1.hex("characters-#{character['id']}-items")] = []
    characters_key = sha1.hex "characters"
    localStorage[characters_key] = JSON.stringify(character_key_list)
    if debug
      console.log "--- #{characters_key} (characters) ---------------"
      console.log localStorage[characters_key]
      console.log "-------------------------------------------------------------------------"

    character_item_key_list = []
    for character_item in data['items']
      character_item_key = sha1.hex "characters-#{character_item['character_id']}-items-#{character_item['id']}"
      localStorage[character_item_key] = JSON.stringify(character_item)
      if debug
        console.log "--- #{character_item_key} (characters-#{character_item['character_id']}-items-#{character_item['id']}) -----"
        console.log localStorage[character_item_key]
        console.log "-------------------------------------------------------------------------"
      characters_items_hash[sha1.hex("characters-#{character_item['character_id']}-items")].push character_item_key
      character_item_key_list.push character_item_key
    characters_items_key = sha1.hex "characters-items"
    localStorage[characters_items_key] = JSON.stringify(character_item_key_list)
    if debug
      console.log "--- #{characters_items_key} (characters-items) ---------"
      console.log localStorage[characters_items_key]
      console.log "-------------------------------------------------------------------------"

    for key of characters_items_hash
      localStorage[key] = JSON.stringify(characters_items_hash[key])
      if debug
        console.log "--- #{key} ----------------------------"
        console.log localStorage[key]
        console.log "-------------------------------------------------------------------------"

    if debug
      console.log "--- localStorage keys ---------------------------------------------------"
      for key of localStorage
        console.log key
      console.log "-------------------------------------------------------------------------"

  return true


fetch_character_list = () ->
  console.log "fetch character list" if debug
  character_key_list = JSON.parse(localStorage[sha1.hex('characters')] || "[]")
  return false if character_key_list.length == 0
  character_list = {}
  for value in character_key_list
    character_list[value] = JSON.parse(localStorage[value] || "{}")
    if debug
      console.log "--- localStorage[#{value}] --------------"
      console.log localStorage[value]
      console.log "-------------------------------------------------------------------------"
  console.log character_list if debug
  return character_list


generate_character_tab_tags = (character_list, target='#result') ->
  console.log "generate character tab tags to '#{target}'." if debug
  tabs_tag         = $(target).addClass('tabbable').append('<ul id="character_list" class="nav nav-tabs"></ul>').find('#character_list')
  tab_contents_tag = $(target).append('<div class="tab-content"></div>').find('.tab-content')
  for character_key of character_list
    console.log "--- character_list[#{character_key}] ------------" if debug
    tab_id = 'tab-' + character_key
    tabs_tag.append '<li><a href="#' + tab_id + '" data-toggle="tab">' + character_list[character_key]['name'] + '</a></li>'
    tab_contents_tag.append '<div class="tab-pane" id="' + tab_id + '"><table class="table"><thead><th>アイテム名</th><th>在庫数</th><th>在庫単価</th><th></th></thead></table></div>'
    console.log "append_tab('##{tab_id}', '" + character_list[character_key]['name'] + "')" if debug
    console.log "-------------------------------------------------------------------------" if debug
  return true


fetch_characters_items = (character_id) ->
  console.log "fetch characters items for #{character_id}" if debug
  character_items_key_list = JSON.parse(localStorage[sha1.hex("characters-#{character_id}-items")] || "[]")
  character_items = []
  for character_items_key in character_items_key_list
    character_item = JSON.parse(localStorage[character_items_key] || "{}")
    character_item['key'] = character_items_key
    character_items.push character_item
    character_items = character_items.concat fetch_characters_items(0) if character_id != 0
  character_items.sort (a,b) ->
    item_a = a['kana']
    item_b = b['kana']
    return -1 if( item_a < item_b ) 
    return 1 if( item_a > item_b )
    return 0
  if debug
    for character_item in character_items
      console.log "--- character_items['#{character_item['key']}'] ---------"
      console.log JSON.stringify(character_item)
      console.log "-------------------------------------------------------------------------"
  return character_items



$ ->
  console.log "Loading my/items."
  bootstrap();
  $("input#del-button").bind 'click', (e) ->
    _stock = parseInt($("#del_stock").val());
    console.log _stock;
    _stock = -1 * _stock if _stock > 0
    
    console.log "=====";
    console.log _stock;
    console.log "=====";
    return false;
  
  renew_my_items_data()
  character_list = fetch_character_list()
  generate_character_tab_tags(character_list)

  for character_key of character_list
    tab_id = 'tab-' + character_key
    console.log "tab_id: #{tab_id}"
    for character_item in fetch_characters_items(character_list[character_key]['id'])
      chara_item_index = sha1.hex("characters-#{character_list[character_key]['id']}-items-#{character_item['id']}")
      console.log "chara_item_index: #{chara_item_index}"
      chara_item_tag = '<tbody id="' + chara_item_index + '">' +
                         '<tr class="character_items">' +
                           '<td class="item_name"><em>' + character_item['name'] + '</em></td>' +
                           '<td class="item_stock"><em>' + character_item['stock'] + '</em>個</td>' +
                           '<td class="item_cost"><em>' + character_item['cost'] + '</em>Ｇ／個</td>' +
                           '<td class="stock_action">' +
                             '<a href="javascript:Application.display_stock_console(\'add\',\'' + chara_item_index + '\');" class="btn btn-mini plus">＋</a>' +
                             '<a href="javascript:Application.display_stock_console(\'del\',\'' + chara_item_index + '\');" class="btn btn-mini minus">−</a>' +
                           '</td>' +
                         '</tr>' + 
                         '<tr class="add_consoles">' +
                           '<td colspan="4">' +
                             '<table class="table table-striped">' +
                               '<tr>' +
                                 '<th>仕入数：</th>' +
                                 '<td class="add_stock"><input type="number" name="add_stock" value="0">個</td>' +
                                 '<td rowspan="2" class="add_action"><a href="javascript:Application.add_calc(\'' + chara_item_index + '\', \'' + sha1.hex("characters-#{character_item['character_id']}-items-#{character_item['id']}") + '\')" class="btn btn-large btn-primary">追加</a></td>' +
                               '</tr>' +
                               '<tr><th>合計金額：</th><td class="add_cost"><input type="text" name="add_total_cost" value="0">Ｇ</td></tr>' +
                             '</table>' +
                           '</td>' +
                         '</tr>' +
                         '<tr class="del_consoles">' +
                           '<td colspan="4">' +
                             '<table class="table table-striped">' +
                               '<tr>' +
                                 '<th>使用数：</th>' +
                                 '<td class="del_stock"><input type="number" name="del_stock" value="0">個</td>' +
                                 '<td class="del_action"><a href="javascript:Application.del_calc(\'' + chara_item_index + '\', \'' + sha1.hex("characters-#{character_item['character_id']}-items-#{character_item['id']}") + '\')" class="btn  btn-danger">削減</a></td></tr>' +
                             '</table>' +
                           '</td>' +
                         '</tr>' +
                       '</tbody>'
      $("##{tab_id} > table").append(chara_item_tag)
      console.log character_item['name']
  $('#character_list li:first-child').addClass("active")
  $(".tab-pane:first-child").addClass("active")

###
