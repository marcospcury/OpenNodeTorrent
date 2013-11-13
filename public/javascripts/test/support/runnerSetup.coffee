global.requirejs = require "requirejs"
global.DEBUG = true
os = require 'os'
path = require 'path'

process.addListener 'uncaughtException', (error) -> console.log "Error happened:\n#{error.stack}"

chai = require 'chai'
chai.should()
chai.use require 'chai-fuzzy'
global.sinon = require 'sinon'
chai.Assertion.includeStack = true
global.expect = chai.expect
sinonChai = require "sinon-chai"
chai.use sinonChai

initDOM = ->
  jsdom = require("jsdom")
  global.window = window = jsdom.jsdom().createWindow("<html><body></body></html>")
  window.XMLHttpRequest = require("xmlhttprequest").XMLHttpRequest
  window.XMLHttpRequest.prototype.withCredentials = false
  global.location = window.location
  global.navigator = window.navigator
  global.XMLHttpRequest = window.XMLHttpRequest
  global.document = window.document
  global.addEventListener = window.addEventListener #for coffeescript compatibility
  unless window.localStorage?
    LocalStorage = require('node-localstorage').LocalStorage
    window.localStorage = new LocalStorage(path.join os.tmpdir(), '.localstorage-test')
    global.localStorage = window.localStorage

configureRequireJS = ->
  require '../../bootstrap'
  requirejs.config
    baseUrl: path.join __dirname, '..', ".."
    nodeRequire: require
    suppress: nodeShim: true
  global.jQuery = window.jQuery = window.$ = global.$ = requirejs 'jquery'

initDOM()
configureRequireJS()
global.exportAll = (obj) ->
  global[key] = value for key,value of obj
g = require './generatorHelper'
exportAll g
