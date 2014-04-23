assert = require 'assert'
fs = require 'fs'
rimraf = require 'rimraf'
thumbnailer = require '../lib/thumbnailer.coffee'
test_img = fs.readFileSync 'test/test.jpg'

describe 'thumbnailer', ->
  afterEach ->
    rimraf.sync 'test/10'
  it 'should thumbnail a file', (done) ->
    thumbnailer.generate 'test/test.jpg', 'test', [10], (err) ->
      assert.equal err, null
      assert fs.existsSync 'test/10/test.jpg'
      done()

  it 'should not thumbnail the same file twice', (done) ->
    thumbnailer.generate 'test/test.jpg', 'test', [10], (err) ->
      assert.equal err, null
      assert fs.existsSync 'test/10/test.jpg'
      outer_stat = fs.statSync 'test/10/test.jpg'
      setTimeout ->
        thumbnailer.generate 'test/test.jpg', 'test', [10], (err) ->
          assert.equal err, null
          inner_stat = fs.statSync 'test/10/test.jpg'
          assert.equal outer_stat.mtime.getTime(), inner_stat.mtime.getTime()
          done()
      , 1000
