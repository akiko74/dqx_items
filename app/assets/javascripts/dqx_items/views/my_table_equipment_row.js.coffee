window.DqxItems.MyTableEquipmentRow = class MyTableEquipmentRow extends Backbone.View

  events:
    'click .equipment_destroy_button':'destroy'

  tagName: "tr"

  render: ->
    row = """
      <td>
        <ruby class="name">
          #{this.model.get('name')}
          <rp>#{this.model.kana}</rp>
        </ruby>
      </td>
      <td class="renkin_count">
        #{this.model.get('renkin_count')}
        <i class="icon-remove-sign equipment_destroy_button"></i>
      </td>
      <td>
        #{this.model.get('cost')}G
      </td>
    """
    this.$el.html(row)
    jQuery("#my_equipment_list tbody").append(this.el)

  destroy:(row) ->
    this.model.destroy()
