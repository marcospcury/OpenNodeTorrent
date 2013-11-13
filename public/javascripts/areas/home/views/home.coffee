define [
  'jquery'
  'underscore'
  'backbone'
  'handlebars'
  'text!./templates/home.html'
  './torrentList'
], ($, _, Backbone, Handlebars, htmlTemplate, TorrentListView) ->
  class HomeView extends Backbone.View
    template: htmlTemplate
    initialize: (opt) ->
      @torrents = opt.torrents
    render: ->
      context = Handlebars.compile @template
      @$el.html context
      @_renderTorrentList()
    _renderTorrentList: ->
      @torrentListView = new TorrentListView torrents: @torrents
      @$('#torrentListPlaceHolder').html @torrentListView.el
