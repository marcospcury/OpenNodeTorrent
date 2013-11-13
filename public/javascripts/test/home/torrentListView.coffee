define = require('amdefine')(module, requirejs) if (typeof define isnt 'function')
define [
  'jquery'
  'areas/home/views/torrentList'
], ($, TorrentListView) ->
  el = $('<div></div>')
  torrentListView = null
  torrentList = generator.torrentList()
  describe 'TorrentListView', ->
    before ->
      torrentListView = new TorrentListView el: el, torrents: torrentList
    it 'should render the torrents view', ->
      expect($('#torrent_list', el).html()).to.not.equal undefined
    it 'should render the torrents list', ->
      expect($('#torrent_list .torrent_row', el).length).to.equal torrentList.length
    it 'should display the torrent name for torrent 1', ->
      expect($('#torrent1 a', el).html()).to.equal torrentList[0].name
    it 'should display the torrent name for torrent 2', ->
      expect($('#torrent2 a', el).html()).to.equal torrentList[1].name
    it 'links to the torrent 1 details page', ->
      expect($('#torrent1 a', el).attr('href')).to.equal torrentList[0].url
