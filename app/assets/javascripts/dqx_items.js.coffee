window.DqxItems =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: ->
    #new DqxItems.Initializer()
    App = new Marionette.Application()
    App.addRegions(
      main: '#recipe_finder'
    )

    ###
    if /^\/recipes/.test location.pathname
      App.addRegions(
        'main': '#recipe_finder'
      )
      console.log "recipes !"
      #jQuery('#recipe_finder').recipeFinder()
    new DqxItems.Views.MaterialListTable()
    App.start()
    ###
    #alert 'Hello from Backbone!'
    console.log App
    console.log App.main

jQuery(document).ready ->
  DqxItems.initialize()


