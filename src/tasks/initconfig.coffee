###

grunt-initconfig
https://github.com/pismute/grunt-initconfig

Copyright (c) 2013 Changwoo Park
Licensed under the MIT license.

###

module.exports = (grunt)->
  _ = grunt.util._
  path = require 'path'

  getExt = (filename)->
    ext = path.extname(filename||'').split('.')
    ext[ext.length - 1]

  readAndMerge = (options) ->
    files = grunt.file.expand options, options.files

    grunt.verbose.writeflags files, 'Files'

    config = {}

    files.forEach (filename)->
      ext = getExt filename
      #basename = path.basename filename, ".#{ext}"
      dirs = (path.dirname filename).split(path.sep)
      fullname = path.join options.cwd, path.sep, filename

      grunt.log.debug(JSON.stringify {filename, ext, dirs, fullname})

      config = _.merge config, (read dirs, ext, fullname)

    config

  read = (dirs, ext, fullname)->
    # resolveHolder
    holder = config = {}

    for dir in dirs
      if dir != '.'
        holder[dir] = holder[dir] || {}
        holder = holder[dir]

    which =
      json: ->
        grunt.file.readJSON fullname
      yaml: ->
        grunt.file.readYAML fullname
      cson: ->
        cson = require 'cson'
        cson.parseFileSync fullname
      js: ->
        js = require path.resolve fullname
        if _.isFunction(js) then js(grunt)  else js
      coffee: ->
        coffee = require path.resolve fullname
        if _.isFunction(coffee) then coffee(grunt)  else coffee
      md: ->
        mdconf = require 'mdconf'
        mdconf grunt.file.read fullname

    holder = _.merge holder, which[ext].call()

    config

  called = false
  grunt.registerTask 'initconfig', 'Your task description goes here.', () ->
    # make sure once
    if called
      grunt.log.writeln 'Skipped'
      return {}
    else
      called = true

    # Merge task-specific and/or target-specific options with these defaults.
    options = @options
      cwd: '.initconfig'
      files: '**/*.{json,yaml,cson,js,coffee,md}'

    grunt.log.debug (JSON.stringify options, false, '  '), 'Options'

    config = _.merge grunt.config.get(), (readAndMerge options)
    grunt.config.init config

    grunt.log.debug (JSON.stringify grunt.config.get(), false, '  ')

  # return for test
  {
    getExt: getExt
    readAndMerge: readAndMerge
    read: read
  }
