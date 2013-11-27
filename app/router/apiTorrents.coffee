_       = require 'underscore'
User    = require '../models/users'
Torrent = require '../models/torrent'

module.exports = class ApiTorrentRoutes
  constructor: ->
  getTorrents: (req, res) =>
    Torrent.find().populate('userUpload').exec (err, torrents) ->
      res.json torrents
  
  getTorrentById: (req, res) =>
    Torrent.findById(req.params.id).populate('userUpload', 'name').exec (err, torrents) ->
      res.json torrents

  postTorrentSeeder: (req, res) =>
    Torrent.findById req.params.id, (err, torrent) ->
      torrent.addSeeder req.params.userId
      torrent.save()
      res.send 200

  deleteTorrentSeeder: (req, res) =>
    Torrent.findById req.params.id, (err, torrent) ->
      torrent.removeSeeder req.params.userId
      torrent.save()
      res.send 200

  postTorrentLeecher: (req, res) =>
    Torrent.findById req.params.id, (err, torrent) ->
      torrent.addLeecher req.params.userId
      torrent.save()
      res.send 200

  deleteTorrentLeecher: (req, res) =>
    Torrent.findById req.params.id, (err, torrent) ->
      torrent.removeLeecher req.params.userId
      torrent.save()
      res.send 200

  searchTorrents: (req, res) =>
    Torrent.search req.params.searchTerm, (err, torrents) ->
      torrentsJson = _.map torrents, (t) -> t.toSimple()
      res.json torrentsJson
