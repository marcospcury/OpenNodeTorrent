exports.start = (cb) ->
  express   = require "express"
  http     = require "http"
  path     = require "path"

  app = express()
  
  app.configure ->
    app.set "port", process.env.PORT || 3000
    app.set "views", "#{__dirname}/views"
    app.set "view engine", "jade"
    app.set "view options", layout: false
    app.use express.favicon()
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use app.router
    app.use express.static(path.join(__dirname, '..', "public"))

  app.configure "development", ->
    app.use express.errorHandler()

  server = http.createServer(app).listen app.get("port"), ->
    console.log "listening on port #{app.get('port')}"
    console.log app.get("env")
