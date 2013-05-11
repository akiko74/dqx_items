
window.DqxItems.Dictionary = class Dictionary

  @dictionary_key: sha1.hex('dictionaries')

  constructor: (@a="sss") ->

  debug_log = (method_name='',message) ->
    DqxItems.Logger.debug("[DqxItems.Dictionary#{method_name}] ", message)

  @reload = (@force=true) ->
    debug_log ".reload()", "--- start ------------------------------------"
    if @force
      destroy_dictionaries()
      jQuery.ajax
        type:     "GET",
        url:      '/dictionaries.json',
        dataType: 'json',
        success:  Dictionary.fetch_dictionary_api_success
        error:    Dictionary.fetch_dictionary_api_error
        complete: Dictionary.fetch_dictionary_api_complete
    debug_log ".reload()", "--- end --------------------------------------"

  @fetch_dictionary_api_success: (data) ->
    debug_log "fetch_dictionary_api_success()", "fetch #{data.length} items."
    destroy_dictionaries()
    save_dictionaries(data)
    for item_data in data
      save_dictionaries_item item_data

  @fetch_dictionary_api_error: ->
    console.log "/-- DqxItems.Dictionary.fetch_dictionary_api_error() -------------------"
    console.log "--- DqxItems.Dictionary.fetch_dictionary_api_error() ------------------/"

  @fetch_dictionary_api_complete: ->
    console.log "/-- DqxItems.Dictionary.fetch_dictionary_api_complete() -------------------"
    console.log "--- DqxItems.Dictionary.fetch_dictionary_api_complete() ------------------/"


  save_dictionaries = (dictionary_data) ->
    DqxItems.DataStorage.set(Dictionary.dictionary_key, dictionary_data)

  destroy_dictionaries = () ->
    count = 0
    for row in DqxItems.DataStorage.keys()
      continue unless row.indexOf(Dictionary.dictionary_key) == 0
      DqxItems.DataStorage.destroy(row)
      count += 1
    debug_log "#destroy_dictionaries()", "destroy #{count} items."

  save_dictionaries_item = (item_data) ->
    DqxItems.DataStorage.set(Dictionary.dictionary_key + sha1.hex(item_data.name), item_data)

  @all: ->
    _dictionary = []
    try
      _dictionary = DqxItems.DataStorage.get(Dictionary.dictionary_key)
    catch e
      debug_log ".all()", "Dictionary cache is not found."
    return _dictionary;

  @get = (item_name) ->
    _key = Dictionary.dictionary_key + sha1.hex item_name
    _item = DqxItems.DataStorage.get _key
    return _item

