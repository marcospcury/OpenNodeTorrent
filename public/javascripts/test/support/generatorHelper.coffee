define = require('amdefine')(module, requirejs) if (typeof define isnt 'function')
define ->
  generator:
    torrent:
      torrent_1: ->
        _id: '1'
        name: 'Torrent movie 1'
        url: '/torrent/torrent_movie_1'
        seeds: '10'
        leechs: '30'
      torrent_2: ->
        _id: '2'
        name: 'Torrent movie 2'
        url: '/torrent/torrent_movie_2'
        seeds: '7'
        leechs: '24'
      torrent_3: ->
        _id: '3'
        name: 'Torrent movie 3'
        url: '/torrent/torrent_movie_3'
        seeds: '90'
        leechs: '130'
    torrentList: ->
      list = []
      list.push @torrent.torrent_1()
      list.push @torrent.torrent_2()
      list.push @torrent.torrent_3()
      list
