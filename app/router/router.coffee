exports.route = (app) ->
  app.get '/', (req, res) =>
    res.render 'index', torrents: [{_id:1, name:'teste', url: 'url'}, {_id:2, name:'teste 2', url: 'url'}]
  app.get '/home', (req, res) =>
    res.render 'index', torrents: [{_id:1, name:'teste', url: 'url'}, {_id:2, name:'teste 2', url: 'url'}]
