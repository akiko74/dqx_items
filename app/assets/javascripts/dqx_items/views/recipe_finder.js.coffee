window.DqxItems.RecipeFinder = class RecipeFinder extends Backbone.View

  el: jQuery('#recipe_finder')
  dictionary: undefined
  target: undefined
  typeaheadSourceList:  undefined
  typeaheadMathcerList: undefined


  initialize: () ->
    if !DqxItems.RecipeFinder.instance

      unless @dictionary = DqxItems.DictionaryItemList.instance
        DqxItems.DictionaryItemList.build()
        @dictionary = DqxItems.DictionaryItemList.instance

      @typeaheadSourceList  = @dictionary.pluck.call({models:@dictionary.where({type:'recipe'}).sort()}, "name")
      @typeaheadMathcerList = _.inject(
        @dictionary.where({type:'recipe'}),
        (memo, recipe) ->
          memo[recipe.get('name')] = recipe.get('kana')
          memo
        ,{})

      DqxItems.RecipeFinder.instance = @
      Backbone.View.apply(DqxItems.RecipeFinder.instance, arguments)
    return DqxItems.RecipeFinder.instance


  @typeaheadMatcher: (query,item) ->
    unless DqxItems.RecipeFinder.instance
      new DqxItems.RecipeFinder()
    itemKana = DqxItems.RecipeFinder.instance.typeaheadMathcerList[item]
    unless itemKana
      return false
    return (itemKana.indexOf(query) == 0)

  typeaheadSource: () ->
    return @typeaheadSourceList

  typeaheadMatcher: (item) ->
    itemKana = @typeaheadMathcerList[item]
    return false unless itemKana
    return (itemKana.indexOf(@$el.find('#recipe_keyword').val()) == 0)


  render: () ->

    html = '''
      <form class="form-search" id="recipe_finder_form">
        <div class="input-append">
          <input autocomplete="off" placeholder="レシピ名を入力" autofocus="autofocus" data-provide="typeahead" type="text" class="search-query" id="recipe_keyword">
          <input value="追加" type="submit" class="btn">
        </div>
      </form>
      <div id="recipe_table">
      </div>
    '''
    @$el.append(html)

    @$el.find('#recipe_finder_form')
      .on('submit', $.proxy(@addRecipeToList, @))

    @$el.find('[type=submit]')
      .attr('disabled', true)

    @$el.find('#recipe_keyword')
      .typeahead({
        source: $.proxy(@typeaheadSource, @)
        items:8
        matcher: $.proxy(@typeaheadMatcher, @)
        highlighter: (item) ->
          regex = new RegExp( '(' + @query + ')', 'gi' )
          item_str = item.replace( regex, "<strong>$1</strong>" )
          return item_str
        updater: $.proxy(@typeaheadUpdater, @)
      })

    (new DqxItems.RecipeTable()).render()
    return @

  typeaheadUpdater: (item) ->
    if @target = (new DqxItems.DictionaryItemList()).where({name:item})[0]
      @$el.find('[type=submit]')
        .attr('disabled', false)
        .addClass('btn-primary')
        .focus()
      return @target.get('name')
    else
      @target = undefined

  addRecipeToList: (e) ->
    return false unless @target
    e.preventDefault()

    recipe = new DqxItems.Recipe({name:@target.get('name'), dictionary:@target})
    DqxItems.RecipeList.addRecipe recipe

    @target = undefined

    @$el.find('[type=submit]')
      .attr('disabled', true)
      .removeClass('btn-primary')

    @$el.find('#recipe_keyword')
      .val('')
      .focus()

    return @
