window.DqxItems.RecipeTableRow = class RecipeTableRow extends Backbone.View

  tagName: 'tr'
  className: 'recipe_table_row'
  recipeList: undefined
  model: undefined

  initialize: (options) ->
    @model = options.model
    @model.on('destroy', $.proxy(@removeElm,@))
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

  appendElm: () ->
    html = """
      <th>#{@popoverRecipeElm(@model)} #{@model.name}</th>
      <td class="recipe_cost">#{@unitPrice(@model)}</td>
      <td class="recipes-action"><a href="#" class=\"btn btn-small btn-danger remove_button\" style=\"color:white\"><i class="icon-minus"></i><span class="recipe_remove_button_text"> 削除</span></a></td>
    """
    @$el.append(html)

    @$el.find('.remove_button')
      .on('click', $.proxy(@clickRemoveButton, @))

    @$el.find('a[rel=popover]')
      .popover()

  clickRemoveButton: () ->
    @model.trigger('destroy')


  unitPrice: (model) ->
    formattedPrice = model.price.toString()
    while(formattedPrice != (formattedPrice = formattedPrice.replace(/^(-?\d+)(\d{3})/, "$1,$2")))
      formattedPrice
    formattedPrice += " G"
    if $.inArray(0,_.pluck(model.items,'unitprice')) == 1
      formattedPrice += ' + <span class="label label-warning">バザー品</span>'
    return formattedPrice


  popoverRecipeElm: (model) ->
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
    _.each @model.items, (item) ->
      DqxItems.MaterialList.removeMaterial(item)
    @remove()
    return @
