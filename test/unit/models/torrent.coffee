Torrent = require '../../../dist/models/torrent'
describe 'Torrent Model', ->
  torrent = null
  before ->
    torrent = new Torrent name: "Torrent 1", slug: "torrent_1"
  it 'Should produce url', (done) ->
    expect(torrent.url()).to.equal "torrent/torrent_1"
    done()
