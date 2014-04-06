window.DqxItems =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: ->
    new DqxItems.Initializer()
    App = new Marionette.Application()
    App.addRegions(
      'main': '#recipe_finder'
    )
    if /^\/recipes/.test location.pathname
      console.log "recipes !"
      #jQuery('#recipe_finder').recipeFinder()
    new DqxItems.Views.MaterialListTable()
    alert 'Hello from Backbone!'
    App.start()

jQuery(document).ready ->
  DqxItems.initialize()


