window.DqxItems.MaterialList = class MaterialList extends Backbone.Collection

  model: DqxItems.Material

  comparator: (a,b) ->
    kana_a = a.dictionary.get("kana")
    kana_b = b.dictionary.get("kana")
    if kana_a > kana_b
      return 1
    else if kana_a < kana_b
      return -1
    return 0

