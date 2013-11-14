mongoose = require 'mongoose'

userSchema = new mongoose.Schema
  email:            String
  passwordHash:     String
  name:             String
  loginError:       Boolean
  verified:         Boolean
  isAdmin:          Boolean
  isModerator:      Boolean

module.exports = User = mongoose.model 'user', userSchema