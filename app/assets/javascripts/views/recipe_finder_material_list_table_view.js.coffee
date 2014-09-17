window.DqxItems.Views.RecipeFinderMaterialListTableView = \
class RecipeFinderMaterialListTableView \
extends Backbone.Marionette.CompositeView

  template:  JST['recipe_finder_material_list_table']
  childView:  DqxItems.Views.RecipeFinderMaterialListItemView
  childViewContainer: 'tbody'
  emptyView: DqxItems.Views.RecipeFinderMaterialListNoItemView

  buildChilsView: (child, childViewClass,childViewOptions) ->
    console.log 'buildChilsView'


  isEmpty: (collection) ->
    console.log 'emptyh/'


  modelEvents:
    change: 'onModelChanged'

  collectionEvents:
    add: 'onCollectionAdded'
    remove: 'onCollectionRemove'

  onModelChanged: ->
    console.log 'change model.'

  onCollectionAdded: (obj1) ->
    console.log 'added collection.'
    console.log obj1
  onCollectionRemove: ->
    console.log 'remove'


