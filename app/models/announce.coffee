bencode = require 'bencode'

module.exports = class Announce
  constructor: (opt) ->
    @user = opt.user
    @torrent = opt.torrent
  handle: (announce, callback) ->
    @torrent.downloads = 0 unless @torrent.downloads?
    @_updateUser announce
    @_updateTorrent announce
    data =
      interval:30
      complete:@torrent.downloads
      incomplete:@torrent.leechers.length
      peers:@torrent.getPeers()
    callback bencode.encode(data)
  _updateTorrent: (announce) ->
    if announce.uploaded > 0
      if announce.event == 'started'
        @torrent.addSeeder user: @user, uploaded:announce.uploaded, port:announce.port, ip: announce.ip
      if announce.event == 'stopped'
        @torrent.removeSeeder @user
    if announce.left > 0
      if announce.event == 'started'
        @torrent.addLeecher user: @user, downloaded:announce.downloaded, port:announce.port, ip: announce.ip
      if announce.event == 'stopped'
        @torrent.removeLeecher @user
    if announce.event == 'completed'
      @torrent.downloads = 0 unless @torrent.downloads?
      @torrent.downloads += 1
      @torrent.removeLeecher @user
    @torrent.save()
  _updateUser: (announce) ->
    @user.profile.uploaded = 0 unless @user.profile.uploaded?
    @user.profile.downloaded = 0 unless @user.profile.downloaded?
    @user.profile.uploaded += announce.uploaded
    @user.profile.downloaded += announce.downloaded
    @user.save()
