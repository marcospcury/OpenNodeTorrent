mongoose  = require 'mongoose'

torrentSchema = new mongoose.Schema
  name:       type: String, required: true
  slug:       String

torrentSchema.methods.url = -> "torrent/#{@slug}"

module.exports = Torrent = mongoose.model 'torrent', torrentSchema
