module My::ItemsHelper

  def partialize_equipments(equipments)
    delete = []
    add = []
    equipments.each do |equipment|
      recipe = Recipe.find_by_name(equipment[:name])
      next unless recipe.present?
        equipment[:recipe_id] = recipe.id
        equipment[:usage_count] = recipe.usage_count
        case
          when equipment[:stock] == -1
            equipment[:stock] = 0
            delete << equipment
          when equipment[:stock] == 1
            add << equipment
        end
      end
      result = {add: add, delete: delete}
      result
  end

  def objectize_item(inventories, user_id)
    result = []
    inventories.each do |inventory|
      item = Item.find_by_name(inventory[:name])
      next unless item.present?
        result << { object: Inventory.where("user_id = ? AND item_id = ?", user_id, item.id).first_or_initialize, name: inventory[:name], stock: inventory[:stock], cost: inventory[:cost]}
    end
  end

  def partialize_items(inventories)
    add = []
    delete = []
      inventories.each do |inventory|
        item = Item.find_by_name(inventory[:name])
        next unless item.present?
          inventory[:item_id] = item.id
          case
            when inventory[:stock] < 0
              delete << inventory
            when inventory[:stock] > 0
              add << inventory
          end
      end
    result = {add: add, delete: delete}
    result
  end

  def things_to_add(requested_equipments_items)
    result =[]
    requested_equipments_items.each do |thing|
      result << thing if thing[:stock] > 0
    end
    result
  end

  def find_equipment(equipments)
    result = []
    equipments.each do |equipment|
      if equipment[:stock] == 1
        recipe = Recipe.find_by_name(equipment[:name])
      end
    end
  end
end
