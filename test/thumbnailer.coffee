assert = require 'assert'
fs = require 'fs'
rimraf = require 'rimraf'
thumbnailer = require '../lib/thumbnailer.coffee'
test_img = fs.readFileSync 'test/test.jpg'

describe 'thumbnailer', ->
  it 'should thumbnail a file', (done) ->
    thumbnailer.generate 'test/test.jpg', 'test', [10], (err) ->
      assert.equal err, null
      assert fs.existsSync 'test/10/test.jpg'
      rimraf.sync 'test/10'
      done()
