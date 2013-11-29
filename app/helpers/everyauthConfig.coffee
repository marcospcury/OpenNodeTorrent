path = require 'path'
everyauth = require 'everyauth'
User = require '../models/users'

exports.configure = (app) ->
  everyauth.password.configure
    loginWith:'email'
    logoutPath:'/account/logout'
    getLoginPath:'/account/login'
    postLoginPath:'/account/login'
    loginSuccessRedirect:'/'
    getRegisterPath: "/account/register"
    postRegisterPath: "/account/register"
    loginView:path.join app.get("views"), "login.jade"
    authenticate:(email, password) ->
    loginLocals: (req, res, cb) ->
      locals =
        if req.query.redirectTo?
          redirectTo: "?redirectTo=#{req.query.redirectTo}"
        else
          redirectTo: ''
      setImmediate -> cb null, locals
    registerUser: (newUserAttrs) ->
    authenticate: (email, password) ->
      cb = @Promise()
      errors = []
      errors.push "Email is required" unless email?
      errors.push "Password is required" unless password?
      return cb.fulfill errors if errors.length isnt 0
      User.findByEmail email.toLowerCase(), (err, user) ->
        return cb.fulfill [err] if err?
        return cb.fulfill ['Login failed: invalid email'] unless user?
        user.verifyPassword password, (error, success) ->
          return cb false if error?
          if success
            cb.fulfill user
          else
            cb.fulfill ['Login failed: invalid password']
      cb
    respondToLoginSucceed: (res, user, data) ->
      return unless user?
      if data.req.query.redirectTo?
        @redirect res, data.req.query.redirectTo
      else
        @redirect res, '/'

  everyauth.everymodule.findUserById (userId, cb) ->
    User.findById userId, (error, user) ->
      cb null, user

  everyauth.everymodule.userPkey '_id'
