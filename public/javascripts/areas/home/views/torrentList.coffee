define [
  'jquery'
  'underscore'
  'backbone'
  'handlebars'
  'text!./templates/_torrentList.html'
], ($, _, Backbone, Handlebars, htmlTemplate) ->
  class TorrentListView extends Backbone.View
    template: htmlTemplate
    initialize: (opt) ->
      @torrents = opt.torrents
      @render()
    render: ->
      context = Handlebars.compile @template
      @$el.html context torrents: @torrents

