window.DqxItems.MyEquipmentsTable = class MyEquipmentsTable extends Backbone.View
  el:"#my_equipment_list"

  initialize: () ->
    table = """
      <table class="table">
        <thead>
          <tr><th>装備品名</th><th>錬金回数</th><th>価格</th></tr>
        </thead>
        <tbody>
        </tbody>
      </table>
    """
    jQuery(this.el).html(table)


  render: () ->
    this.collection.each (my_equipment) ->
      (new DqxItems.MyTableEquipmentRow({model:my_equipment})).render()


