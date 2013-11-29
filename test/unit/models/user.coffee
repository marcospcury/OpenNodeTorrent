User = require '../../../dist/models/users'

describe 'User Model', ->
  user = null
  passwordEncrypted = null
  userSaveSpy = sinon.stub().yields()

  before ->
    bcrypt = require 'bcrypt'
    salt = bcrypt.genSaltSync 10
    passwordEncrypted = bcrypt.hashSync 'abc', salt

    user = new User
      name: 'User 1'
      password: 'abc'
      email: 'user@torrent.com'
    user.setPassword 'abc'
    user.save = sinon.stub().yields()
  
  it 'Should have a password set', (done) ->
    user.passwordHash.should.be.defined
    done()
  it 'Should verify the correct password', (done) ->
    user.verifyPassword 'abc', (err, result) ->
      expect(result).to.be.true
      done()
  it 'Should verify the wrong password', (done) ->
    user.verifyPassword '123', (err, result) ->
      expect(result).to.be.false
      expect(user.loginError).to.equal 1
      done()
