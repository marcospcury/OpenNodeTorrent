path = require 'path'
everyauth = require 'everyauth'

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
      cb.fulfill _id:'123', name:'user'
      cb
    respondToLoginSucceed: (res, user, data) ->
      return unless user?
      if data.req.query.redirectTo?
        @redirect res, data.req.query.redirectTo
      else
        @redirect res, '/'

  everyauth.everymodule.findUserById (userId, cb) ->
    cb null, _id:userId, name:'user'

  everyauth.everymodule.userPkey '_id'
