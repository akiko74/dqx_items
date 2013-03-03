$ ->
  $.getJSON '/my/items.json', (data, status) ->
    localStorage.clear()
    for key of data
      console.log key
      ary = []
      for value in data[key]
        index = sha1.hex("#{key}-#{value['id']}")
        localStorage[index] = JSON.stringify(value)
        ary.push index
        console.log sha1.hex("#{key}-#{value['id']}") + "(#{key}-#{value['id']}) : #{value}"
      localStorage[key] = JSON.stringify(ary)

  for value in JSON.parse(localStorage['items'])
    item_data = JSON.parse localStorage[value]
    console.log item_data
    index = sha1.hex("characters-#{item_data['character_id']}-items")
    characters_items = JSON.parse(localStorage[index] || "[]")
    characters_items.push value
    localStorage[index] = JSON.stringify characters_items
    console.log sha1.hex("characters-#{item_data['character_id']}-items") + "(characters-#{item_data['character_id']}-items) : #{characters_items}"

  character_list = $('#result').addClass('tabbable').append('<ul id="character_list" class="nav nav-tabs"></ul>').find('#character_list')
  tab_content    = $('#result').append('<div class="tab-content"></div>').find('.tab-content')
  for value in JSON.parse(localStorage['characters'])

    character_data = JSON.parse localStorage[value]
    console.log "character_key : #{value}"
    console.log "character_data:---"
    console.log character_data
    console.log "------------------"
    console.log "characters_items_key: " + sha1.hex("characters-#{character_data['id']}-items") + "(characters-#{character_data['id']}-items)"

    item_list = JSON.parse(localStorage[sha1.hex("characters-#{character_data['id']}-items")] || "[]")
    console.log "characters-#{character_data['id']}-items_data:---"
    console.log item_list
    console.log "---------------------------"
    common_item_list = JSON.parse(localStorage[sha1.hex("characters-0-items")] || "[]")
    console.log "characters-0-items_data:---"
    console.log common_item_list
    console.log "---------------------------"
    item_list = item_list.concat common_item_list
    console.log "all_item_list:---"
    console.log item_list
    console.log "-----------------"

    character_list.append '<li><a href="#tab-' + value + '" data-toggle="tab">' + character_data['name'] + '</a></li>'
    tab_id = 'tab-' + value 
    tab_content.append '<div class="tab-pane" id="' + tab_id + '"><table class="table"><thead><th>アイテム名</th><th>在庫数</th><th>在庫単価</th><tbody></tbody></table></div>'
    console.log "append_tab(##{tab_id})"

    charactors_items = []
    for value in item_list
      console.log '=== ' + value
      console.log localStorage[value]
      console.log "append to ##{tab_id} tbody"
      item = JSON.parse(localStorage[value])
      charactors_items.push(item)

    charactors_items.sort (a,b) ->
      item_a = a['kana']
      item_b = b['kana']
      return -1 if( item_a < item_b ) 
      return 1 if( item_a > item_b )
      return 0

    for item in charactors_items
      $("##{tab_id} tbody").append('<tr><td>' + item['name'] + '</td><td>' + item['stock'] + '個</td><td>' + item['cost'] + 'Ｇ／個</td></tr>')

  $('#character_list li:first-child').addClass("active")
  $(".tab-pane:first-child").addClass("active")


