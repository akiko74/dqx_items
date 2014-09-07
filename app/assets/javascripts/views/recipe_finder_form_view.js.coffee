window.DqxItems.Views.RecipeFinderFormView = class RecipeFinderFormView extends Marionette.ItemView

  template: JST['recipe_finder_form']


  onBeforeRender: ->
    @engine = new Bloodhound({
      name: 'recipes'
      local: []
      datumTokenizer: (d) ->
        Bloodhound.tokenizers.whitespace(d.name)
      queryTokenizer: Bloodhound.tokenizers.whitespace
    })
    @engine.initialize()


  collectionEvents:
    request: 'guardInput'
    sync:    'rebuildTypeahead'
    error:   'handleError'


  handleError: (error) ->
    @$el.prepend """
      <div class="alert alert-danger alert-dismissable">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        #{error}
      </div>
    """
    throw error


  guardInput: ->
    @$el.find('#recipe_keyword')
      .attr('disabled', 'disabled')
      .attr('placeholder', 'Loading...')
      .val('')
    @$el.find('[type=submit]').attr('disabled', 'disabled')


  rebuildTypeahead: ->
    @engine.clear()

    @engine.add(
      @collection.where(type:'recipe').map (item) ->
        {
          name: item.name,
          kana: item.kana,
          key:  item.key
        }
    )
    @$el.find('#recipe_keyword')
      .removeAttr('disabled')
      .attr('placeholder', 'レシピ名を入力')
      .focus()
      .val('')


  onRender: ->
    @$el.find('#recipe_keyword')
      .typeahead({
        highlight:  true,
        autoselect: true
      }, {
        displayKey: 'name',
        source: @engine.ttAdapter()
      })
      .on(
        'typeahead:selected typeahead:autocompleted',
        $.proxy(@typeaheadSelected, @)
      )
    @$el.find('#recipe_keyword_button').on('click', $.proxy(@clicked, @))
    @$el.find('form').on('submit', $.proxy(@submited, @))
    @resetInputs()
    @guardInput()



  clicked: ->
    @resetInputs()


  resetInputs: ->
    @$el.find('#recipe_keyword_button').hide()
    @$el.find('#recipe_keyword_fields').css('display','inline-block')
    @$el.find('#recipe_keyword_name').html('')
    @$el.find('[type=submit]').attr('disabled', 'disabled')
    @$el.find('#recipe_keyword')
      .removeAttr('readonly')
      .removeAttr('disabled')
      .focus()
      .val('')


  submited: (e) ->
    @$el.find('[type=submit]').attr('disabled', 'disabled')
    e.preventDefault()

    inputedName    = @$el.find('#recipe_keyword').val()

    recipe = new DqxItems.Models.RecipeFinderRecipe(
      name: inputedName,
      dictionary: @collection )

    recipe.fetch(
      success: $.proxy(@fetchRecipeSuccessed, @)
      error: (obj1,obj2) ->
        console.log 'error'
        console.log obj1
        console.log obj2
    )

    @resetInputs()
    return false

  typeaheadSelected: (obj, datum, name) ->
    @$el.find('#recipe_keyword_name').html(@$el.find('#recipe_keyword').val())
    @$el.find('#recipe_keyword_button').show()
    @$el.find('#recipe_keyword_fields').hide()
    @$el.find('[type=submit]').removeAttr('disabled').focus()


  fetchRecipeSuccessed: (model, response, options) ->
    console.log 'fetchRecipeSuccessed'
    @options.recipes.add(model)
    console.log @
    console.log @$el.find('#recipe_keyword')
    console.log @$el.find('#recipe_keyword').val()
    console.log @engine


  tmp: ->
    for item in model.items
      if elm = @options.materials.findWhere({ name: item.name})
        @options.materials.remove(elm)
        elm.set('count', (elm.count + item.count))
        @options.materials.add(elm)
      else
        @options.materials.add item
    console.log @options.materials
    @options.materials.sort()

