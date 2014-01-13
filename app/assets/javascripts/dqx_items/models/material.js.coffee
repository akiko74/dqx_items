window.DqxItems.Material = class Material extends Backbone.Model

  defaults: {
    'name': undefined
    'unitprice': -1
    'count': -1
  }
  attributes: {}
  dictionary: undefined

  initialize: (params) ->
    @name = params.name
    unless @dictionary = params.dictionary
      @dictionary = (new DqxItems.DictionaryItemList()).where({name:params.name})[0]
    @attributes = { name:@get('name'), unitprice:@get('unitprice'), count:@get('count') }

