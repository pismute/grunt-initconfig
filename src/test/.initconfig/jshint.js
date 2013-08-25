/*

grunt-initconfig
https://github.com/pismute/grunt-initconfig

Copyright (c) 2013 Changwoo Park
Licensed under the MIT license.
*/


module.exports = function(grunt) {
  return {
    jshint: {
      options: {
        jshintrc: '.jshintrc'
      },
      tasks: {
        src: ['src/tasks/**/*.js']
      },
      test: {
        src: ['src/test/**/*.js']
      }
    }
  };
};
