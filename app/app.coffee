exports.start = (cb) ->
  express   = require "express"
  http      = require "http"
  path      = require "path"
  mongoose  = require "mongoose"
  router    = require './router/router'
  everyauth = require 'everyauth'
  everyauthConfig = require './helpers/everyauthConfig'
  MongoStore = require('connect-mongo')(express)

  app = express()
  
  #sessionStore = new MongoStore url:'mongodb://localhost/opentorrent'
  sessionStore = new express.session.MemoryStore()

  app.set "port", process.env.PORT || 3000
  app.set "views", "#{__dirname}/views"
  app.set "view engine", "jade"
  app.set "view options", layout: false
  app.use express.favicon()
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser 'somesecret'
  app.use express.session secret:'somesecret', store:sessionStore
  app.use express.static(path.join(__dirname, '..', "public"))

  everyauthConfig.configure app
  app.use everyauth.middleware()

  mongoose.connect 'mongodb://localhost/opentorrent'

  router.route app

  app.configure "development", ->
    app.use express.errorHandler()

  server = http.createServer(app).listen app.get("port"), ->
    console.log "listening on port #{app.get('port')}"
    console.log app.get("env")
