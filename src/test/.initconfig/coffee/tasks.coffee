###

grunt-initconfig
https://github.com/pismute/grunt-initconfig

Copyright (c) 2013 Changwoo Park
Licensed under the MIT license.

###

module.exports = (grunt)->
  tasks:
    expand: true
    cwd: 'src/tasks/'
    src: ['**/*.coffee']
    dest: 'tasks/'
    ext: '.js'

