define [
  'backbone'
], (Backbone) ->
  class OpenRouter extends Backbone.Router
    initialize: ->
      Backbone.history.start()
      super()
