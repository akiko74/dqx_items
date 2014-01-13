window.DqxItems.MaterialListTable = class MaterialListTable extends Backbone.View

  el:"#material_list_table"
  template: _.template($("#tmpl-material_list_table").html())


  initialize: (options) ->
    @collection.on('add', @addRow, @)


  render: () ->
    @$el.html(@template())
    return @

  addRow: ->
    tbody = @$el.find('tbody').html('')
    for material in @collection.models
      tbody.append (new DqxItems.MaterialTableRow({model:material, collection:@collection})).render()
    return @

