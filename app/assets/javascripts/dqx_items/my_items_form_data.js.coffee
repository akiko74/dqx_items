#my_items_form_data.js.coffee
window.DqxItems.MyItemsFormData = class MyItemsFormData

  debug: true

  debugLog: (methodName='',message) ->
    DqxItems.Logger.debug(
      "[DqxItems.MyItemsFormData#{methodName}] ",
      message
    )

  itemCost: NaN
  itemStock: NaN
  itemTotalCost: NaN
  keyword: ""
  deleteItemStock: NaN
  renkinCount: NaN
  renkinTotalCost: NaN
  deleteRenkinStock: NaN

  constructor: (params={}) ->
    @debugLog "#constructor()", params
    @itemCost          = params.itemCost          if params.itemCost?
    @itemStock         = params.itemStock         if params.itemStock?
    @itemTotalCost     = params.itemTotalCost     if params.itemTotalCost?
    @keyword           = params.keyword           if params.keyword?
    @deleteItemStock   = params.deleteItemStock   if params.deleteItemStock?
    @renkinCount       = params.renkinCount       if params.renkinCount?
    @renkinTotalCost   = params.renkinTotalCost   if params.renkinTotalCost?
    @deleteRenkinStock = params.deleteRenkinStock if params.deleteRenkinStock?

  checkItemAddable: ->
    if @debug
      @debugLog "#checkItemAddable()", "isFinite(@itemCost) = #{(isFinite(@itemCost))}"
      @debugLog "#checkItemAddable()", "isFinite(@itemStock) = #{(isFinite(@itemStock))}"
      @debugLog "#checkItemAddable()", "isFinite(@itemTotalCost) = #{(isFinite(@itemTotalCost))}"
      @debugLog "#checkItemAddable()", "(@itemStock > 0) = #{(@itemStock > 0)}"
    return ( isFinite(@itemCost) && isFinite(@itemStock) && isFinite(@itemTotalCost) && @itemStock > 0 )

  checkItemDeletable: ->
    if @debug
      @debugLog "#checkItemDeletable()", "isFinite(@deleteItemStock) = #{(isFinite(@deleteItemStock))}"
      @debugLog "#checkItemDeletable()", "(@deleteItemStock > 0) = #{(@deleteItemStock > 0)}"
    return ( isFinite(@deleteItemStock) && @deleteItemStock > 0 )

  checkRenkinAddable: ->
    if @debug
      @debugLog "#checkRenkinAddable()", "isFinite(@renkinTotalCost) = #{(isFinite(@renkinTotalCost))}"
    return ( isFinite(@renkinTotalCost) )

  checkRenkinDeletable: ->
    if @debug
      @debugLog "#checkRenkinDeletable()", "isFinite(@deleteRenkinStock) = #{isFinite(@deleteRenkinStock)}"
    #isFinite(_input_del_stock) && _input_del_stock != 0 && typeof inputed_item()['my'] != "undefined")
    return (isFinite(@deleteRenkinStock))

  dictionary: ->
    return (new DqxItems.Collections.DictionaryItemList()).where({name:@keyword})[0]

  toAddItemParam: ->
    return {
      name: @keyword,
      stock: @itemStock,
      cost: @itemTotalCost
    }

  toDeleteItemParam: ->
    del_stock = @deleteItemStock
    if (@deleteItemStock > 0)
      del_stock = @deleteItemStock * -1
    return {
      name: @keyword,
      stock: del_stock
    }

  toAddEquipmentParam: ->
    return {
      name: @keyword,
      stock: 1,
      renkin_count: @renkinCount,
      cost: @renkinTotalCost
    }

  toDeleteEquipmentParam: ->
    return {
      name: @keyword,
      stock: -1,
      renkin_count: @renkinCount,
      cost: @renkinTotalCost
    }



