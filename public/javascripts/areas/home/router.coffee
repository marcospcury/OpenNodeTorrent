define [
  'backboneConfig',
  './routes'
], (Backbone, routes) ->
  class Router extends Backbone.Open.Router
    routes:
      '': routes.home
      'home': routes.home
