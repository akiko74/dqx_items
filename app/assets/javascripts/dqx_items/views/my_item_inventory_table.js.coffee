window.DqxItems.MyItemInventoryTable = class MyItemInventoryTable extends Backbone.View
  el:"#my_item_list"

  initialize: () ->
    table = """
      <table class="table">
        <thead>
          <tr><th>アイテム名</th><th>在庫数</th><th>単価</th></tr>
        </thead>
        <tbody>
        </tbody>
      </table>
    """
    jQuery(this.el).html(table)


  render: () ->
    this.collection.each (my_item_inventory) ->
      (new DqxItems.MyTableItemInventoryRow({model:my_item_inventory})).render()


