Announce = require '../../../dist/models/announce'
Torrent = require '../../../dist/models/torrent'
User = require '../../../dist/models/users'
bencode = require 'bencode'

describe 'Announce Model', ->
  announce = null
  user = null
  seeder = null
  leecher = null
  torrent = null
  announceData = null
  callbackSpy = sinon.spy()
  userSaveSpy = sinon.spy()
  torrentSaveSpy = sinon.spy()

  before ->
    user = new User
      name: 'user1'
      profile: [
        uploaded:0
        downloaded:0
       ]
    user.save = userSaveSpy
    seeder = new User name: 'seeder'
    leecher = new User name: 'leecher'
    torrent = new Torrent name: 'Torrent - 1'
    torrent.addSeeder { user:seeder, uploaded:10, ip:'8.8.8.8', port:10}
    torrent.addLeecher { user:leecher, uploaded:10, ip:'8.8.8.8', port:10}
    torrent.save = torrentSaveSpy

    announceData =
      info_hash: 'torrent_hash'
      peer_id: 'utorrent'
      port: 5430
      ip: '1.1.1.1'
      uploaded: 0
      downloaded: 0
      left: 0
      event: ''

  describe 'Started event', ->
    before ->
      announceData.event = 'started'

    describe 'User is a seeder', ->
      before ->
        announceData.uploaded = 10
        announce = new Announce user:user, torrent:torrent
        announce.handle announceData, callbackSpy
      it 'Should add the upload ammount to the user profile', (done) ->
        expect(user.profile.uploaded).to.equal 10
        userSaveSpy.should.have.been.called
        done()
      it 'Should add the user as seeder on torrent', (done) ->
        expect(torrent.seeders.length).to.equal 2
        torrentSaveSpy.should.have.been.called
        done()
      it 'Should not add the user as a leecher on torrent', (done) ->
        expect(torrent.leechers.length).to.equal 1
        done()
    describe 'User is a leecher', ->
      before ->
        torrent.removeSeeder user
        announceData.uploaded = 0
        announceData.downloaded = 10
        announceData.left = 20
        announce = new Announce user:user, torrent:torrent
        announce.handle announceData, callbackSpy
      it 'Should add the download ammount to the user profile', (done) ->
        expect(user.profile.downloaded).to.equal 10
        userSaveSpy.should.have.been.called
        done()
      it 'Should add the user as leecher on torrent', (done) ->
        expect(torrent.leechers.length).to.equal 2
        torrentSaveSpy.should.have.been.called
        done()
      it 'Should not add the user as a seeder on torrent', (done) ->
        expect(torrent.seeders.length).to.equal 1
        done()
  describe 'Stopped event', ->
    before ->
      announceData.event = 'stopped'
    describe 'User is a seeder', ->
      before ->
        torrent.addSeeder { user:user, uploaded:10, ip:'8.8.8.8', port:10}
        announceData.uploaded = 10
        announce = new Announce user:user, torrent:torrent
        announce.handle announceData, callbackSpy
      it 'Should remove the user from the seeder list', (done) ->
        expect(torrent.seeders.length).to.equal 1
        torrentSaveSpy.should.have.been.called
        done()
    describe 'User is a leecher', ->
      before ->
        torrent.addLeecher { user:user, uploaded:10, ip:'8.8.8.8', port:10}
        announceData.uploaded = 0
        announceData.downloaded = 10
        announceData.left = 20
        announce = new Announce user:user, torrent:torrent
        announce.handle announceData, callbackSpy
      it 'Should remove the user from the leecher list', (done) ->
        expect(torrent.leechers.length).to.equal 1
        torrentSaveSpy.should.have.been.called
        done()
  describe 'Completed event', ->
    before ->
      announceData.event = 'completed'
      torrent.addSeeder {user:user, uploaded:10, ip:'8.8.8.8', port:10}
      torrent.addLeecher {user:user, downloaded:10, ip:'8.8.8.8', port:10}
      announceData.uploaded = 10
      announce = new Announce user:user, torrent:torrent
      announce.handle announceData, callbackSpy
    it 'Should remove the user from the leecher list', (done) ->
      expect(torrent.seeders.length).to.equal 2
      expect(torrent.leechers.length).to.equal 1
      torrentSaveSpy.should.have.been.called
      done()
    it 'Should update torrents download count', (done) ->
      expect(torrent.downloads).to.equal 1
      torrentSaveSpy.should.have.been.called
      done()
  describe 'Tracker response', ->
    before ->
      announceData.event = 'started'
      announceData.uploaded = 10
      announceData.downloaded = 10
      announceData.left = 20
      announce = new Announce user:user, torrent:torrent
    it 'Should respond the torrent client properly', (done) ->
      announce.handle announceData, (data) ->
        response = bencode.decode data, 'utf8'
        expect(response.interval).to.equal 30
        expect(response.complete).to.equal 1
        expect(response.incomplete).to.equal 2
        expect(response.peers.length).to.equal 4
        done()
