###

grunt-initconfig
https://github.com/pismute/grunt-initconfig

Copyright (c) 2013 Changwoo Park
Licensed under the MIT license.

###

module.exports = (grunt)->
  test:
    expand: true
    cwd: 'src/test/'
    src: ['**/*.coffee']
    dest: 'out/test/'
    ext: '.js'

