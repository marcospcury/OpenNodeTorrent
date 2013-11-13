define = require('amdefine')(module, requirejs) if (typeof define isnt 'function')
define [
  'jquery'
  'areas/home/views/home'
], ($, HomeView) ->
  el = $('<div></div>')
  homeView = null
  torrentList = generator.torrentList()
  describe 'HomeView', ->
    before ->
      homeView = new HomeView el: el, torrents: torrentList
      homeView.render()
    it 'should render the home view', ->
      expect($('#homeView', el).html()).to.not.equal undefined
    it 'should render the torrent list', ->
      expect($('#homeView #torrent_list', el).html()).to.not.equal undefined
      expect($('#homeView #torrent_list tr', el).length).to.equal torrentList.length
