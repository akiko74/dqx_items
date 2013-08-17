window.DqxItems.MyTableItemInventoryRow = class MyTableItemInventoryRow extends DqxItems.MyTableRow

  el: "#my_item_list tbody"

  render: ->
    row = """$
      <tr>
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
      </tr>
    """
    jQuery(this.el).append(row)
    return this

