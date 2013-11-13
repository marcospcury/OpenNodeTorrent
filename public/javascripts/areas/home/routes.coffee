define [
  'jquery'
  'underscore'
  'backbone'
  './views/home'
  'viewsManager'
], ($, _, Backbone, HomeView, viewsManager) ->
  class Routes
    constructor: ->
      viewsManager.$el = $ '#app-container'
    home: ->
      @homeView = new HomeView torrents: torrentList
      viewsManager.show @homeView
  _.bindAll new Routes()
