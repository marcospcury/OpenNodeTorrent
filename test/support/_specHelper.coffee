process.env.NODE_ENV = 'teste'
global.DEBUG = true
require './libs'

exportAll = (obj) ->
  global[key] = value for key, value of obj

global.exportAll = exportAll
exports.exportAll = exportAll
