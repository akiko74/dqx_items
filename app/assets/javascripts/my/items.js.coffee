window.Application ||= {}

debug = true

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
