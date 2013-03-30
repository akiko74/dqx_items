
window.DqxItems.Dictionary = class Dictionary

  @dictionary_key: sha1.hex('dictionaries')

  constructor: (@a="sss") ->

  debug_log = (method_name='',message) ->
  #  DqxItems.Logger.debug("[DqxItems.Dictionary#{method_name}] ", message)

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
    debug_log "fetch_dictionary_api_success()", "--- start ------------------------------------"
    debug_log "fetch_dictionary_api_success()", " arguments: data"
    debug_log "fetch_dictionary_api_success()", data
    debug_log "fetch_dictionary_api_success()", " - - - - - - - - - - - - - - - - - - - - - - -"
    destroy_dictionaries()
    save_dictionaries(data)
    for item_data in data
      save_dictionaries_item item_data
    debug_log "fetch_dictionary_api_success()", "--- end --------------------------------------"

  @fetch_dictionary_api_error: ->
    console.log "/-- DqxItems.Dictionary.fetch_dictionary_api_error() -------------------"
    console.log "--- DqxItems.Dictionary.fetch_dictionary_api_error() ------------------/"

  @fetch_dictionary_api_complete: ->
    console.log "/-- DqxItems.Dictionary.fetch_dictionary_api_complete() -------------------"
    console.log "--- DqxItems.Dictionary.fetch_dictionary_api_complete() ------------------/"


  save_dictionaries = (dictionary_data) ->
    debug_log "#save_dictionaries()", dictionary_data
    debug_log "#save_dictionaries()", Dictionary.dictionary_key
    debug_log "#save_dictionaries()", DqxItems.DataStorage.set(Dictionary.dictionary_key, dictionary_data)

  destroy_dictionaries = () ->
    debug_log "#destroy_dictionaries()", "--- Start ---"
    for row in DqxItems.DataStorage.keys()
      continue unless row.indexOf(Dictionary.dictionary_key) == 0
      DqxItems.DataStorage.destroy(row)
      debug_log "#destroy_dictionaries()", row
    debug_log "#destroy_dictionaries()", "--- End ---"

  save_dictionaries_item = (item_data) ->
    debug_log "#save_dictionaries_item()", item_data
    debug_log "#save_dictionaries_item()", DqxItems.DataStorage.set(Dictionary.dictionary_key + sha1.hex(item_data.name), item_data)

  @all: ->
    debug_log ".all()", "--- Start ---"
    _dictionary = []
    try 
      _dictionary = DqxItems.DataStorage.get(Dictionary.dictionary_key)
    catch e
      debug_log ".all()", "Dictionary cache is not found."
   
    debug_log ".all()", "--- End ---"
    return _dictionary;

