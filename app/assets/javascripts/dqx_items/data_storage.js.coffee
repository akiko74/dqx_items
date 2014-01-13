
window.DqxItems.DataStorage = class DataStorage

  @set = (key, value, engin=localStorage, json_serialize=true) ->
    if json_serialize
      engin[key] = JSON.stringify value
    else
      engin[key] =  value
    return { key: key, value: engin[key] }

  @get = (key, engin=localStorage) ->
    return JSON.parse engin[key]

  @keys = (engin=localStorage) ->
    _keys = new Array()
    for key of engin
       _keys.push key
    return _keys

  @destroy = (key, engin=localStorage) ->
    return engin.removeItem(key)

  @exist = (key, engin=localStorage) ->
    return engin[key]?

  @raw_get = (key, engin=localStorage) ->
    return engin[key]

  @raw_set = (key, value, engin=localStorage) ->
    engin[key] = value
    return { key: key, value: engin[key] }
