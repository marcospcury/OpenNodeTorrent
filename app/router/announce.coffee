Announce = require '../models/announce'
Torrent = require '../models/torrent'
User = require '../models/users'
 
module.exports = class AnnounceRoutes
  constructor: ->
  getAnnounce: (req, res) =>
    Torrent.findById(req.params.torrentId).populate('leechers.user').exec (err, torrent) ->
      return res.send 500 if err?
      User.findById req.params.userId, (err, user) ->
        return res.send 500 if err?
        announceData = req.query
        announceData.ip = '1.1.1.1'
        announce = new Announce user:user, torrent:torrent
        announce.handle announceData, (response) ->
          res.setHeader 'Content-Type', 'text/plain'
          res.send response
