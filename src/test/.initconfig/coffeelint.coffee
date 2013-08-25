###

grunt-initconfig
https://github.com/pismute/grunt-initconfig

Copyright (c) 2013 Changwoo Park
Licensed under the MIT license.

###

module.exports = (grunt)->
  coffeelint:
    gruntfile:
      src: 'Gruntfile.coffee'
    tasks:
      src: ['src/tasks/*.coffee']
    test:
      src: ['src/test/*.coffee']
    options:
      no_trailing_whitespace:
        level: 'error'
      max_line_length:
        level: 'warn'

