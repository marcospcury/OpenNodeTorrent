module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    coffee:
      app:
        expand:true
        cwd: 'app'
        src: ['**/*.coffee']
        dest: 'dist'
        ext: '.js'
        options:
          bare:true
      public:
        expand:true
        cwd: 'public'
        src: ['**/*.coffee', '!javascripts/lib/**/*']
        dest: 'public'
        ext: '.js'
        options:
          bare:true
      test:
        expand:true
        cwd: 'test'
        src: ['**/*.coffee']
        dest: 'test'
        ext: '.js'
        options:
          bare:true
 
    copy:
      main:
        files: [{
          expand: true
          cwd: 'app/'
          src: ['**/*.!(coffee)']
          dest: 'dist/'
          }]
      public:
        files: [{
          expand: true
          cwd: 'public/'
          src: ['**/*.!(coffee)']
          dest: 'compiledPublic/'
          }]

    mochacov:
      options:
        require: ['public/javascripts/test/support/runnerSetup.js']
        reporter: 'spec'
      client: ['public/javascripts/test/**/*.js']
      server_unit:
        src: ['test/unit/**/*.js']
        require: ['test/support/_specHelper.js']

    nodemon:
      dev:
        options:
          file: 'server.js'
          watchedExtensions: ['js']
          watchedFolders: ['dist']
          nodeArgs: ['--debug']
          delayTime: 2
          env:
            NODE_ENV: 'development'
            PORT: 3000
          cwd: __dirname

    shell:
      nodeInspector:
        command: 'node-inspector'
        options:
          stdout: true

    watch:
      compile:
        files: [ 'app/**/*.coffee', 'public/**/*.coffee']
        tasks: [ 'compile' ]
        options:
          nospawn: true
      compileAndTest:
        files: [ 'test/**/*.coffee', 'app/**/*.jade', 'app/**/*.coffee', 'public/**/*.coffee']
        tasks: [ 'wait:watch', 'compileAndTest' ]
        options:
          nospawn: true

    concurrent:
      devServer:
        tasks: [ 'watch:compileAndTest', 'nodemon:dev', 'nodeInspector' ]
        options:
          logConcurrentOutput: true

    bower:
      install:
        options:
          target: 'public/javascripts/lib'
          copy: false
          verbose: true

    wait:
      watch:
        options:
          delay: 1000
          after: ->
            return true unless grunt.util._.isEmpty changedFiles
            undefined

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-express-server'
  grunt.loadNpmTasks 'grunt-bower-task'
  grunt.loadNpmTasks 'grunt-contrib-qunit'
  grunt.loadNpmTasks 'grunt-mocha-cov'
  grunt.loadNpmTasks 'grunt-curl'
  grunt.loadNpmTasks 'grunt-nodemon'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-concurrent'
  grunt.loadNpmTasks 'grunt-wait'
  grunt.loadNpmTasks 'grunt-shell'

  _ = grunt.util._
  filterFiles = (files, dir) ->
    _.chain(files)
     .filter((f) -> _(f).startsWith dir)
     .map((f)->_(f).strRight "#{dir}/")
     .value()

  changedFiles = {}
  onChange = grunt.util._.debounce ->
    files = Object.keys(changedFiles)
    serverFiles = filterFiles files, 'app'
    testFiles = filterFiles files, 'test'
    clientFiles = filterFiles files, 'public'
    grunt.config ['server', 'src'], serverFiles
    grunt.config ['test', 'src'], testFiles
    grunt.config ['client', 'src'], clientFiles
    grunt.config ['dev'], []
    changedFiles = {}
  , 1000
  grunt.event.on 'watch', (action, filepath) ->
    changedFiles[filepath] = action
    onChange()

  grunt.registerTask 'compile', ['coffee', 'copy:main']
  grunt.registerTask 'compile:client', ['coffee:public']
  grunt.registerTask 'compile:server', ['coffee:app']
  grunt.registerTask 'compile:test', ['coffee:test']
  grunt.registerTask 'test:client', ['compile:client', 'mochacov:client']
  grunt.registerTask 'test:travis', ['compile', 'mochacov']
  grunt.registerTask 'test:unit', ['compile:test', 'compile:server', 'mochacov:server_unit']
  grunt.registerTask 'nodeInspector', [ 'shell:nodeInspector' ]
  grunt.registerTask 'compileAndTest', ->
    tasks = []
    if grunt.config(['client', 'src']).length isnt 0
      tasks.push 'test:client'
      grunt.log.writeln "Running #{'client'.blue} unit tests"
    if grunt.config(['server', 'src']).length isnt 0 or grunt.config(['test', 'src']).length isnt 0
      tasks.push 'test:unit'
      grunt.log.writeln "Running #{'server'.blue} unit tests"
    grunt.task.run tasks
  grunt.registerTask 'heroku', ->
    home = process.env.HOME
    if home?.substr(0,11) is "/tmp/build_" #trying to identify heroku
      grunt.task.run [ 'compile', 'bower' ]
  grunt.registerTask 'default', ['compile', 'concurrent:devServer']
  grunt.registerTask 'watch:test', ['watch:compileAndTest']
