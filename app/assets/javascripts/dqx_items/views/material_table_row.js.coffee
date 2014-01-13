window.DqxItems.MaterialTableRow = class MaterialTableRow extends Backbone.View

  tagName: 'tr'
  model: undefined

  initialize: (options) ->
    @model = options.model
    @model.on('destroy', $.proxy(@removeElm,@))
    @model.on('change', $.proxy(@changeElm,@))
    @id = @model.dictionary.get('key')

  render: () ->
    @$el
      .attr('id', @id)
      .css('height','0px')
      .animate(
        {
          height:'30px'
        },
        300,

        $.proxy(@appendElm, @)
      )

  changeElm: () ->
    @$el.fadeOut().html('')
    @appendElm()
    @$el.fadeIn()

  appendElm: () ->
    html = """
      <th>#{@model.name}</th>
      <td class="material_count">#{@model.get('count')}</th>
      <td class="material_price">#{@unitPrice(@model.get('unitprice'))}</td>
      <td class="material_button"><a href="/items?keyword=#{@model.name}" class="btn btn-warning btn-small"><i class="icon-th-list"></i><span class="material_action_text"> レシピ</span></a></td>
    """
    @$el.append(html)


  unitPrice: (unitprice) ->
    return '<span class="label label-warning">バザーのみ</span>'if unitprice == 0
    formattedPrice = unitprice.toString()
    while(formattedPrice != (formattedPrice = formattedPrice.replace(/^(-?\d+)(\d{3})/, "$1,$2")))
      formattedPrice
    return "#{formattedPrice}G"

  popoverMaterialElm: (model) ->
    recipe = ""
    _.each model.items, (item) ->
      itemElm = "<li>#{item.name} × #{item.count} "
      if item.unitprice == 0
        itemElm += "<span class='label label-warning'>バザー品</span>"
      itemElm += "</li>"
      recipe += itemElm
    """
      <a href="#" class="recipe_name" rel="popover" data-html="true" data-content="<ul>#{recipe}</ul>" data-title="#{model.name}のレシピ"><i class="icon-th-list"></i></a>
    """

  removeElm: () ->
    @remove()
