grunt = require 'grunt'

grunt_initconfig = require '../../tasks/initconfig'

###
======== A Handy Little Mocha Reference ========
https://github.com/visionmedia/should.js
https://github.com/visionmedia/mocha

Mocha hooks:
  before ()-> # before describe
  after ()-> # after describe
  beforeEach ()-> # before each it
  afterEach ()-> # after each it

Should assertions:
  should.exist('hello')
  should.fail('expected an error!')
  true.should.be.ok
  true.should.be.true
  false.should.be.false

  (()-> arguments)(1,2,3).should.be.arguments
  [1,2,3].should.eql([1,2,3])
  should.strictEqual(undefined, value)
  user.age.should.be.within(5, 50)
  username.should.match(/^\w+$/)

  user.should.be.a('object')
  [].should.be.an.instanceOf(Array)

  user.should.have.property('age', 15)

  user.age.should.be.above(5)
  user.age.should.be.below(100)
  user.pets.should.have.length(5)

  res.should.have.status(200) #res.statusCode should be 200
  res.should.be.json
  res.should.be.html
  res.should.have.header('Content-Length', '123')

  [].should.be.empty
  [1,2,3].should.include(3)
  'foo bar baz'.should.include('foo')
  { name: 'TJ', pet: tobi }.user.should.include({ pet: tobi, name: 'TJ' })
  { foo: 'bar', baz: 'raz' }.should.have.keys('foo', 'bar')

  (()-> throw new Error('failed to baz')).should.throwError(/^fail.+/)

  user.should.have.property('pets').with.lengthOf(4)
  user.should.be.a('object').and.have.property('name', 'tj')
###

describe 'initconfig', ->
  describe 'should', ->
    grunt = require('grunt')
    _ = grunt.util._

    initconfig = grunt_initconfig grunt

    it 'should return final extention.', ->
      initconfig.getExt('init.config.grunt').should.eql 'grunt'

    it 'should read a .md file.', ->
      (initconfig.read ['grun', 't'], 'md'
      , 'src/test/.initconfig/simplemocha.md').should.eql
        grun:
          t:
            simplemocha:
              options:
                timeout: '3000'
                ignoreleaks: 'false'
                ui: 'bdd'
                reporter: 'spec'
                globals: [
                  'should'
                ]
              test:
                src: [
                  'node_modules/should/lib/should.js'
                  'out/test/**/*.js'
                ]

    it 'should read a .coffee file.', ->
      (initconfig.read ['grun', 't'], 'coffee'
      , 'src/test/.initconfig/coffee/tasks.coffee').should.eql
        grun:
          t:
            tasks:
              expand: true
              cwd: 'src/tasks/'
              src: ['**/*.coffee']
              dest: 'tasks/'
              ext: '.js'

    it 'should read a .json file.', ->
      (initconfig.read ['grun', 't'], 'json'
      , 'src/test/.initconfig/clean.json').should.eql
        grun:
          t:
            clean: [
              'out/'
              'tasks/'
              '*.js'
              '*.js.map'
              'src/**/*.js'
              'src/**/*.js.map'
            ]

    it 'should read a .yaml file.', ->
      (initconfig.read ['grun', 't'], 'yaml'
      , 'src/test/.initconfig/copy.yaml').should.eql
        grun:
          t:
            copy:
              tasks:
                files: [
                  expand: true
                  cwd: 'src/tasks'
                  src: [
                    '**/*.js'
                  ]
                  dest: 'tasks/'
                ]
              test:
                files: [
                  expand: true
                  cwd: 'src/test'
                  src: [
                    '**/*.js'
                  ]
                  dest: 'out/test'
                ]

    it 'should read a .js file.', ->
      (initconfig.read ['grun', 't'], 'js'
      , 'src/test/.initconfig/jshint.js').should.eql
        grun:
          t:
            jshint:
              options:
                jshintrc: '.jshintrc'
              tasks:
                src: ['src/tasks/**/*.js']
              test:
                src: ['src/test/**/*.js']

    it 'should read a .cson file.', ->
      (initconfig.read ['grun', 't'], 'cson'
      , 'src/test/.initconfig/watch.cson').should.eql
        grun:
          t:
            watch:
              gruntfile:
                files: '<%= coffeelint.gruntfile.src %>'
                tasks: [
                    'coffeelint:gruntfile'
                  ]
              jsTasks:
                files: '<%= jshint.tasks.src %>'
                tasks: [
                    'jshint:tasks'
                    'test'
                  ]
              jsTest:
                files: '<%= jshint.test.src %>'
                tasks: [
                    'jshint:test'
                    'test'
                  ]
              coffeeTasks:
                files: '<%= coffeelint.tasks.src %>'
                tasks: [
                    'coffeelint:tasks'
                    'coffee:tasks'
                    'test'
                  ]
              coffeeTest:
                files: '<%= coffeelint.test.src %>'
                tasks: [
                    'coffeelint:test'
                    'coffee:test'
                    'test'
                  ]

    it 'should read all of files and merge them.', ->
      (initconfig.readAndMerge
        cwd: 'src/test/.initconfig'
        files: ['**/*.{coffee,md}', '!**/coffeelint.coffee']
      ).should.eql
        coffee:
          test:
            expand: true
            cwd: 'src/test/'
            src: ['**/*.coffee']
            dest: 'out/test/'
            ext: '.js'
          tasks:
            expand: true
            cwd: 'src/tasks/'
            src: ['**/*.coffee']
            dest: 'tasks/'
            ext: '.js'
        simplemocha:
          options:
            timeout: '3000'
            ignoreleaks: 'false'
            ui: 'bdd'
            reporter: 'spec'
            globals: [
              'should'
            ]
          test:
            src: [
              'node_modules/should/lib/should.js'
              'out/test/**/*.js'
            ]

