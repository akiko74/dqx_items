window.DqxItems.Collections.RecipeFinderMaterialList = class RecipeFinderMaterialList extends Backbone.Collection

  model: DqxItems.Models.RecipeFinderMaterial

  comparator: (a,b) ->
    kana_a = a.get('dictionary').kana.toString()
    kana_b = b.get('dictionary').kana.toString()
    if kana_a > kana_b
      return 1
    else if kana_a < kana_b
      return -1
    return 0

