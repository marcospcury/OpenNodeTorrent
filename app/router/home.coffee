_               = require 'underscore'
User            = require '../models/users'
Torrent         = require '../models/torrent'
everyauth       = require 'everyauth'
RouterFunctions = require './routerFunctions'

module.exports = class HomeRoutes
  constructor: ->
    @_auth 'getHome'
  _.extend @::, RouterFunctions::
  getHome: (req, res) ->
    Torrent.find().populate('userUpload').exec (err, torrents) ->
      torrentsJson = _.map torrents, (t) -> t.toSimple()
      res.render 'index', torrents: torrentsJson
