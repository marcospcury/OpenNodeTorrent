requirejs.config
  paths:
    jquery: 'lib/jquery/jquery'
    underscore: 'lib/underscore/underscore'
    backbone: 'lib/backbone/backbone'
    handlebars: 'lib/handlebars/index'
    text: 'lib/requirejs-text/text'
    sinon: 'lib/sinon/lib/sinon'
    twitterBootstrap: 'lib/bootstrap/dist/js/bootstrap'
  shim:
    'jqueryui':
      deps: ['jquery']
      exports: 'jqueryui'
    'handlebars':
      deps: ['jquery']
      exports: 'Handlebars'
    'jqueryAlert':
      deps: ['jquery']
    'twitterBootstrap':
      deps: ['jquery']
    'underscore':
      exports: '_'
    'backbone':
      deps: ['jquery', 'underscore']
      exports: 'Backbone'
