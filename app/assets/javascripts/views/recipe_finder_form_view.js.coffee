window.DqxItems.Views.RecipeFinderFormView = class RecipeFinderFormView extends Marionette.ItemView

  template: JST['recipe_finder_form']

  ui:
    keyword_form: '#recipe_finder_form'
    keyword_field: '#recipe_keyword'
    keyword_fields: '#recipe_keyword_fields'
    keyword_submit: '#recipe_finder_form button[type=submit]'
    keyword_cancel: '#recipe_keyword_button'
    keyword_name: '#recipe_keyword_name'
    keyword_loading: '#recipes_loading'
    keyword_field_wrapper: '#recipe_keyword_wrapper'


  events:
    'click @ui.keyword_cancel': 'onClickedCancelButton'
    'submit @ui.keyword_form': 'onSubmitedKeyword'

  collectionEvents:
    request: 'guardInput'
    sync:    'rebuildTypeahead'
    error:   'handleError'



  ## pragma mark Marionette.ItemView hooks

  # onBeforeRender hook with Marionette.ItemView
  #   @return [Boolean] true when success
  #   @nodoc
  onBeforeRender: ->
    @initTypeaheadEngine()
    true


  # onRender hook with Marionette.ItemView
  #   @return [Boolean] true when success
  #   @nodoc
  onRender: ->
    @bindEventsToElements()
    true



  ## pragma mark @ui.keyword_cancel hooks

  # onClick hook with @ui.keyword_cancel
  #   @return [Boolean] true when success
  onClickedCancelButton: ->
    @resetInputs()
    true



  ## pragma mark @ui.keyword_form hooks

  # onSubmited hook with @ui.keyword_form
  #   @return [Boolean] false when success
  onSubmitedKeyword: (e) ->
    @blockKeywordSubmit()
    e.preventDefault()
    @fetchRecipeByName(@inputedName())
    @resetInputs()
    false



  ## pragma mark Main logic

  # Initialize typeahead engine
  #   @return [Bloodhound] typeahead engine when success
  initTypeaheadEngine: ->
    @engine = new Bloodhound
                name: 'recipes'
                local: []
                datumTokenizer: (d) ->
                  Bloodhound.tokenizers.whitespace(d.name)
                queryTokenizer: Bloodhound.tokenizers.whitespace
    @engine.initialize()
    @engine


  # Guard input fields
  #   @return [Boolean] true when success
  guardInput: ->
    @ui.keyword_field.attr('disabled', 'disabled').val('')
    @blockKeywordSubmit()


  # Rebuild typeahead data from collection
  #   @return [Boolean] true when success
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
    @ui.keyword_loading.hide()
    @ui.keyword_field.show().removeAttr('disabled').val('').focus()
    @ui.keyword_field_wrapper.show()
    true


  # Event binder to rendered forms
  #   @return [Boolean] true when success
  bindEventsToElements: ->
    @ui.keyword_field
      .typeahead({
        highlight:  true,
        autoselect: true
      }, {
        displayKey: 'name',
        source: @engine.ttAdapter()
      })
      .on(
        'typeahead:selected typeahead:autocompleted',
        $.proxy(@onTypeaheadSelected, @)
      )
    @ui.keyword_field_wrapper.hide()
    @resetInputs()
    @guardInput()
    @collection.fetch()
    true


  resetInputs: ->
    @ui.keyword_cancel.hide()
    @ui.keyword_fields.css('display','inline-block')
    @ui.keyword_name.html('')
    @blockKeywordSubmit()
    @ui.keyword_field
      .removeAttr('readonly')
      .removeAttr('disabled')
      .focus()
      .val('')


  # Block double submit
  #   @return [Boolean] true when success
  blockKeywordSubmit: ->
    @ui.keyword_submit.attr('disabled', 'disabled')
    true

  # Unlock keyword submit
  #   @return [Boolean] true when success
  unlockKeywordSubmit: ->
    @ui.keyword_submit.removeAttr('disabled').focus()
    true

  # Fetch recipe by name
  #   @param [String] name Recipe name
  #   @return [DqxItems.Models.RecipeFinderRecipe] Recipe when success
  fetchRecipeByName: (name) ->
    recipe = new DqxItems.Models.RecipeFinderRecipe
               name: name
               dictionary: @collection
    recipe.fetch
             success: $.proxy(@onSuccessedFetchRecipe, @)
             error: $.proxy(@onFailedFetchRecipe, @)
    recipe


  # Inputed name
  #   @return [String] Recipe name when return success
  inputedName: ->
    @ui.keyword_field.val()


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


  handleError: (error) ->
    @$el.prepend """
      <div class="alert alert-danger alert-dismissable">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        #{error}
      </div>
    """
    throw error


  # Enable recipe button with RecipeName
  #   @param [String] recipe_name
  #   @return [Object] @ui.keyword_cancel
  enableRecipeButton: (recipe_name) ->
    @ui.keyword_name.html(recipe_name)
    @ui.keyword_cancel.show()


  # Hide keyword field
  #   @return [Object] @ui.keyword_fields
  hideKeywordField: ->
    @ui.keyword_fields.hide()



  ## pragma mark DqxItems.Models.RecipeFinderRecipe#fetch hook

  # onSuccessed hook with DqxItems.Models.RecipeFinderRecipe#fetch
  onSuccessedFetchRecipe: (model, response, options) ->
    @options.recipes.add(model)


  # onErrored hook with DqxItems.Models.RecipeFinderRecipe#fetch
  onFailedFetchRecipe: (obj1, obj2) ->
    console.log 'error'
    console.log obj1
    console.log obj2



  ## pragma mark Bloodhound hooks

  # onSelected or onAutocompleted hook with Bloodhound
  #   @see typeahead:selected typeahead:autocompleted
  #   @see Bloodhound
  onTypeaheadSelected: (obj, datum, name) ->
    @enableRecipeButton(@inputedName())
    @hideKeywordField()
    @unlockKeywordSubmit()

