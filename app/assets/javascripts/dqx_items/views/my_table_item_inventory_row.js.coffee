window.DqxItems.MyTableItemInventoryRow = class MyTableItemInventoryRow extends DqxItems.MyTableRow

  tagName: "tr"

  events:
    'click .icon-minus-sign':'del'
    'click .icon-plus-sign':'add'

  render: ->
    row = """$
      <td>
        <ruby>
          #{this.model.get('name')}
          <rp>#{this.model.get('kana')}</rp>
        </ruby>
      </td>
      <td>
        <i class="icon-minus-sign"></i>
        #{this.model.get('stock')}個
        <i class="icon-plus-sign"></i>
      </td>
      <td>
        #{this.model.get('cost') * this.model.get('stock')}G
      </td>
    """
    this.$el.html(row)
    jQuery("#my_item_list tbody").append(this.el)

  add: ->
    jQuery("#keyword").val(this.model.get('name'))
    DqxItems.MyItemsFormBuilder.init_my_item_inventory_controll_panel()
    jQuery("#{DqxItems.MyItemsFormBuilder.my_items_add_tab_id} a").click()

  del: ->
    jQuery("#keyword").val(this.model.get('name'))
    DqxItems.MyItemsFormBuilder.init_my_item_inventory_controll_panel()
    jQuery("#{DqxItems.MyItemsFormBuilder.my_items_del_tab_id} a").click()

