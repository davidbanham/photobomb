assert = require 'assert'
t2 = require 'through2'
fs = require 'fs'
rimraf = require 'rimraf'
thumb_stream = require '../lib/thumb_stream.coffee'

describe 'thumb_stream', ->
  afterEach ->
    rimraf.sync 'test/10'

  it 'should thumbnail a file', (done) ->
    generator = thumb_stream.generate()
    file = {from: 'test/test.jpg', to: 'test', sizes: [10]}

    checker = t2.obj (chunk, enc, cb) ->
      assert.equal chunk, file
      assert fs.existsSync 'test/10/test.jpg'
      done()

    generator.pipe checker

    generator.write file
