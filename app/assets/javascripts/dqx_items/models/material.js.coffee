window.DqxItems.Material = class Material extends Backbone.Model

  @material_key: DqxItems.CodeGenerator.generate("materials")

  defaults: {
    'name': undefined
    'unitprice': -1
    'count': -1
  }
  attributes: {}
  dictionary: undefined

  constructor: (params) ->
    @id   = DqxItems.Material.material_key +
      DqxItems.CodeGenerator.generate(params.name)
    @name = params.name
    unless @dictionary = params.dictionary
      @dictionary = (new DqxItems.DictionaryItemList()).where({name:params.name})[0]
    if params.unitprice && params.count
      @unitprice = params.unitprice * params.count
    else
      @unitprice = -1

    unless @count     = params.count
      @count = -1

    @attributes = { name:@name, unitprice:@unitprice, count:@count }

