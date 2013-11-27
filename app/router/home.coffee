_       = require 'underscore'
User    = require '../models/users'
Torrent = require '../models/torrent'

module.exports = class HomeRoutes
  constructor: ->
  getHome: (req, res) =>
    Torrent.find().populate('userUpload').exec (err, torrents) ->
      torrentsJson = _.map torrents, (t) -> t.toSimple()
      res.render 'index', torrents: torrentsJson
