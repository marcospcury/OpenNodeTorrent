mongoose = require 'mongoose'

userSchema = new mongoose.Schema
  email:            String
  passwordHash:     String
  name:             String
  loginError:       Boolean
  verified:         Boolean
  isAdmin:          Boolean
  isModerator:      Boolean
  loginError:       Number
  resetKey:         Number
  profile: [
    uploaded: Number
    downloaded: Number
  ]
  invitedBy: type: mongoose.Schema.Types.ObjectId, ref: 'user'

userSchema.methods.setPassword = (password) ->
  bcrypt = require 'bcrypt'
  salt = bcrypt.genSaltSync 10
  @passwordHash = bcrypt.hashSync password, salt
  @resetKey = undefined

userSchema.methods.verifyPassword = (passwordToVerify, cb) ->
  bcrypt = require 'bcrypt'
  bcrypt.compare passwordToVerify, @passwordHash, (error, succeeded) =>
    if succeeded
      if @loginError isnt 0
        @loginError = 0
      else
        return cb null, true
    else
      @loginError++
    @save (err, u) =>
      cb error, succeeded

module.exports = User = mongoose.model 'user', userSchema

User.findByEmail = (email, cb) -> User.findOne email: email, cb
