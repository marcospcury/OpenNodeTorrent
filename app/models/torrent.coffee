mongoose = require 'mongoose'
_        = require 'underscore'

torrentSchema = new mongoose.Schema
  name:               type: String, required: true
  description:        type: String, required: true
  url:                String
  category:           String
  keywords:           [String]
  numFiles:           Number
  files: [
    name:             String
    size:             Number
  ]
  numComments:        type: Number, default: -> 0
  added:              type: Date, default: -> new Date()
  size:               Number
  downloads:          type: Number, default: -> 0
  seeders: [
    user: type: mongoose.Schema.Types.ObjectId, ref: 'user'
    port: Number
    ip: String
    uploaded: Number
  ]
  leechers: [
    user: type: mongoose.Schema.Types.ObjectId, ref: 'user'
    port: Number
    ip: String
    downloaded: Number
  ]
  numSeeders:         type: Number, default: -> 0
  numLeechers:        type: Number, default: -> 0
  userUpload:         type: mongoose.Schema.Types.ObjectId, ref: 'user'
  screenshots:        [String]
  imdbId:             String

torrentSchema.methods.toSimple = ->
   _id: @_id
   name: @name
   description: @description
   slug: @slug
   numFiles: @numFiles
   numComments: @numComments
   added: @added
   size: @size
   numSeeders: @numSeeders
   numLeechers: @numLeechers
   uploaded: @userUpload.name

torrentSchema.path('name').set (val) ->
  @url = "torrent/#{@_id}"
  cleanWords = val.replace('- ', '').toLowerCase()
  @keywords = cleanWords.replace('-', '').split " "
  val

torrentSchema.path('files').set (val) ->
  @size = 0 unless @size?
  @size += file.size for file in val
  @numFiles = val.length
  val

torrentSchema.methods.addSeeder = (peerInfo) ->
  user = _.findWhere(@seeders, {user: peerInfo.user._id})
  if user?
    user.uploaded += peerInfo.uploaded
  else
    @seeders.push _id:peerInfo.user._id, user:peerInfo.user, uploaded:peerInfo.uploaded, ip:peerInfo.ip, port:peerInfo.port
    @numSeeders = 0 unless @numSeeders?
    @numSeeders += 1
   
torrentSchema.methods.addLeecher = (peerInfo) ->
  user = _.findWhere(@leechers, {user: peerInfo.user._id})
  if user?
    user.downloaded += peerInfo.downloaded
  else
    @leechers.push _id:peerInfo.user._id, user:peerInfo.user, downloaded:peerInfo.downloaded, ip:peerInfo.ip, port:peerInfo.port
    @numLeechers = 0 unless @numLeechers
    @numLeechers += 1

torrentSchema.methods.removeSeeder = (user) ->
  @seeders.id(user.id).remove()
  @numSeeders -= 1

torrentSchema.methods.removeLeecher = (user) ->
  @leechers.id(user.id).remove()
  @numLeechers -= 1

torrentSchema.methods.getPeers = ->
  peers = []
  _.map @seeders, (s) -> peers.push port:s.port, ip:s.ip
  _.map @leechers, (l) -> peers.push port:l.port, ip:l.ip
  peers

module.exports = Torrent = mongoose.model 'torrent', torrentSchema

Torrent.search = (searchTerm, cb) ->
  Torrent.find(keywords: searchTerm.toLowerCase()).populate('userUpload').exec (err, torrents) ->
    return cb err if err
    cb null, torrents
