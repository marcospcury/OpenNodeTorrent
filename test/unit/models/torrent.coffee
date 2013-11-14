Torrent = require '../../../dist/models/torrent'
User = require '../../../dist/models/users'

describe 'Torrent Model', ->
  torrent = null
  user = null
  userSeeder = null
  userSeeder2 = null
  userLeecher = null
  userLeecher2 = null

  before ->
    user = new User name: 'user1'
    userSeeder = new User name: 'user_seeder'
    userSeeder2 = new User name: 'user_seeder_2'
    userLeecher = new User name: 'user_leecher'
    userLeecher2 = new User name: 'user_leecher_2'

    torrent = new Torrent
      name: "Torrent 1"
      files: [{name: 'file 1', size: 10}, {name: 'file 2', size:15}, {name: 'file 3', size:15}]
      userUpload: user

  it 'Should produce url', (done) ->
    expect(torrent.url).to.equal "torrent/#{torrent._id}"
    done()
  it 'Should produce keywords from the torrent name', (done) ->
    expect(torrent.keywords.length).to.equal 2
    done()
  it 'Should count the number of files the torrent contains', (done) ->
    expect(torrent.numFiles).to.equal 3
    done()
  it 'Should sum the total files size', (done) ->
    expect(torrent.size).to.equal 40
    done()
  it 'Should have default values', (done) ->
    expect(torrent.downloads).to.equal 0
    expect(torrent.numSeeders).to.equal 0
    expect(torrent.numLeechers).to.equal 0
    expect(torrent.numComments).to.equal 0
    expect(torrent.added.getDate()).to.equal new Date().getDate()
    done()
  it 'Should produce simple model', (done) ->
    simple = torrent.toSimpleTorrent()
    expect(simple._id).to.equal torrent._id
    expect(simple.name).to.equal torrent.name
    expect(simple.description).to.equal torrent.description
    expect(simple.numFiles).to.equal torrent.numFiles
    expect(simple.numComments).to.equal torrent.numComments
    expect(simple.added).to.equal torrent.added
    expect(simple.size).to.equal torrent.size
    expect(simple.numSeeders).to.equal torrent.numSeeders
    expect(simple.numLeechers).to.equal torrent.numLeechers
    expect(simple.uploaded).to.equal torrent.userUpload.name
    done()
  it 'Should add a new seeders', (done) ->
    torrent.addSeeder userSeeder
    torrent.addSeeder userSeeder2
    expect(torrent.numSeeders).to.equal 2
    done()
  it 'Should remove one specific seeder', (done) ->
    torrent.removeSeeder userSeeder
    expect(torrent.numSeeders).to.equal 1
    expect(torrent.seeders[0].user).to.equal userSeeder2._id
    done()
