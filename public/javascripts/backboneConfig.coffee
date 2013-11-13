define [
  'backbone'
  './openRouter'
], (Backbone, OpenRouter) ->
  Backbone.Open = {}
  Backbone.Open.Router = OpenRouter
  return Backbone
