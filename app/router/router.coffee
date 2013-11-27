_           = require 'underscore'
Home        = require './home'
ApiTorrent  = require './apiTorrents'
Announce    = require './announce'

exports.route = (app) ->
  home = new Home()
  announce = new Announce()
  apiTorrent = new ApiTorrent()

  app.get     '/',                                                    home.getHome
  app.get     '/announce/:torrentId/:userId',                         announce.getAnnounce
  app.get     '/api/torrents',                                        apiTorrent.getTorrents
  app.get     '/api/torrents/:id',                                    apiTorrent.getTorrentById
  app.post    '/api/torrents/:id/seeders/:userId',                    apiTorrent.postTorrentSeeder
  app.delete  '/api/torrents/:id/seeders/:userId',                    apiTorrent.deleteTorrentSeeder
  app.post    '/api/torrents/:id/leechers/:userId',                   apiTorrent.postTorrentLeecher
  app.delete  '/api/torrents/:id/leechers/:userId',                   apiTorrent.deleteTorrentLeecher
  app.get     '/api/torrents/search/:searchTerm',                     apiTorrent.searchTorrents
