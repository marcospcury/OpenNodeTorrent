mongoose = require 'mongoose'

torrentSchema = new mongoose.Schema
  name:               type: String, required: true
  description:        type: String, required: true
  url:                String
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
  numSeeders:         type: Number, default: -> 0
  numLeechers:        type: Number, default: -> 0
  userUpload:         type: mongoose.Schema.Types.ObjectId, ref: 'user'
  screenshots:        [String]
  imdbId:             String

torrentSchema.methods.toSimpleTorrent = ->
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
  @keywords = val.split " "
  val
torrentSchema.path('files').set (val) ->
  @size = 0 unless @size?
  @size += file.size for file in val
  @numFiles = val.length
  val

module.exports = Torrent = mongoose.model 'torrent', torrentSchema
