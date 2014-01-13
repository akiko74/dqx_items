window.DqxItems.RecipeTable = class RecipeTable extends Backbone.View

  el: '#recipe_table'
  recipeList: undefined
  materialList: undefined

  initialize: () ->
    if !DqxItems.RecipeTable.instance

      @recipeList = (new DqxItems.RecipeList())
      @recipeList.bind('add', $.proxy(@addRecipeRow,@))
#      @recipeList.bind('remove', $.proxy(@removeRecipeRow,@))

      @materialList = (new DqxItems.MaterialList())
      @materialList.bind('add', $.proxy(@addMaterialRow,@))
#      @materialList.bind('remove', $.proxy(@removeMaterialRow,@))

      DqxItems.RecipeTable.instance = @
      Backbone.View.apply(DqxItems.RecipeTable.instance, arguments)
    return DqxItems.RecipeTable.instance

  addRecipeRow: (item) ->
    @$el.find("#default_contents").slideUp(100)
    @$el.find("#recipe_materials").slideDown(300)
    recipeRow = new DqxItems.RecipeTableRow({model:item})
    @$el.find("#recipe_list_table").append recipeRow.render()
    return @


  removeRecipeRow: (item) ->
    item.destroy()

  addMaterialRow: (item) ->
    materialRow = new DqxItems.MaterialTableRow({model:item})
    @$el.find('#material_list_table').append materialRow.render()

  removeMaterialRow: (item) ->
    console.log 'removeMaterialRow'

  render: () ->
    @$el = $('#recipe_table')

    html = ''
    if @recipeList.length == 0
      html = '''
        <div id="default_contents" class="alert alert-info">
          レシピを検索して必要な素材とお店で素材を買った時の値段をチェック！<br>
          レシピを続けて検索すると、必要な素材の合計数も出るので職人の依頼に便利です。<br>
        </div>
        <div id="recipe_materials" style="display:none;">
          <section>
            <h2>レシピリスト</h2>
            <table id="recipe_list_table" class="table">
              <thead>
                <tr>
                  <th class="recipe_name">レシピ名</th>
                  <th class="recipe_cost">原価合計 <small>（バザー除く）</small></th>
                  <th class="recipe_buttons"><a href="/recipes" class="btn btn-small btn-inverse all_remove_button" style="color:white"><i class="icon-remove"></i><span class="recipes_all_remove_button_text"> 全削除</span></a></th>
                </tr>
              </thead>
              <tbody>
              </tbody>
            </table>
          </section>

          <section>
            <h2>必要素材</h2>
            <table id="material_list_table" class="table">
              <thead>
                <tr>
                  <th>アイテム名</th>
                  <th class="material_count">合計必要数</th>
                  <th class="material_price">購入金額</th>
                  <td class="material_button"></td>
                </tr>
              </thead>
              <tbody>
              </tbody>
            </table>
          </section>
        </div>
      '''
    @$el.append(html)

