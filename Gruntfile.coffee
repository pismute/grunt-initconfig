###

grunt-initconfig
https://github.com/pismute/grunt-initconfig

Copyright (c) 2013 Changwoo Park
Licensed under the MIT license.

###

module.exports = (grunt)->
  # load all grunt tasks
  (require 'matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  _ = grunt.util._
  path = require 'path'

  # Project configuration.
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    coffeelint:
      gruntfile:
        src: '<%= watch.gruntfile.files %>'
      tasks:
        src: '<%= watch.tasks.files %>'
      test:
        src: '<%= watch.test.files %>'
      options:
        no_trailing_whitespace:
          level: 'error'
        max_line_length:
          level: 'warn'
    coffee:
      tasks:
        expand: true
        cwd: 'src/tasks/'
        src: ['**/*.coffee']
        dest: 'tasks/'
        ext: '.js'
      test:
        expand: true
        cwd: 'src/test/'
        src: ['**/*.coffee']
        dest: 'out/test/'
        ext: '.js'
    simplemocha:
      options:
        globals: ['should']
        timeout: 3000
        ignoreLeaks: false
        #grep: '*-test'
        ui: 'bdd'
        reporter: 'spec'
      all:
        src: [
          'node_modules/should/lib/should.js'
          'out/test/**/*.js'
        ]
    watch:
      options:
        spawn: false
      gruntfile:
        files: 'Gruntfile.coffee'
        tasks: [
          'coffeelint:gruntfile'
        ]
      tasks:
        files: ['src/tasks/**/*.coffee']
        tasks: [
          'coffeelint:tasks'
          'coffee:tasks'
        ]
      test:
        files: ['src/test/**/*.coffee']
        tasks: [
          'coffeelint:test'
          'coffee:test'
        ]
    clean: [
      'out/'
      'tasks/'
      '*.{js,js.map}'
      'src/**/*.{js,.js.map}'
    ]

  # Actually load this plugin's task(s).
  # grunt.loadTasks 'src/tasks'

  grunt.event.on 'watch', (action, files, target)->
    grunt.log.writeln "#{target}: #{files} has #{action}"

    # coffeelint
    grunt.config ['coffeelint', target], src: files

    # coffee
    coffeeData = grunt.config ['coffee', target]
    files = [files] if _.isString files
    files = _.map files, (file)-> path.relative coffeeData.cwd, file
    coffeeData.src = files

    grunt.config ['coffee', target], coffeeData

  # By default, lint and run all tests.
  grunt.registerTask 'default', [
    'compile'
    #'test'
  ]

  # lint, copy
  grunt.registerTask 'compile', [
    'coffeelint'
    'coffee'
  ]

  # test
  grunt.registerTask 'test', [
    'simplemocha'
  ]
