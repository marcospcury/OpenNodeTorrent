module.exports = class AccountRoutes
  constructor: ->
  getLogin: (req, res) =>
    res.render 'login'
