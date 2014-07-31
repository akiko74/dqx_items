window.DqxItems =
  Models: {}
  Collections: {}
  Controllers: {}
  Regions: {}
  Views: {}
  Routers: {}
  Utils: {}

  initialize: ->
    App = new Marionette.Application()
    App.addInitializer ->
      Backbone.history.stop() if Backbone.History.started
      if /^\/recipes/.test location.pathname
        new DqxItems.Routers.RecipeFinderRouter()
      Backbone.history.start()
    App.start()

jQuery(document).on "ready page:load", ->
  DqxItems.initialize()


