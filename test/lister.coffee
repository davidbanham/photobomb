assert = require 'assert'
lister = require '../lib/lister'
fs = require 'fs'
exec = require('child_process').exec

describe 'lister', ->
  before ->
    fs.mkdirSync './list_test'
    fs.mkdirSync './list_test/sub'
    fs.writeFileSync './list_test/one.jpg'
    fs.writeFileSync './list_test/two.jpg'

  after ->
    exec 'rm -rf ./list_test'

  it 'should return a correct tree', (done) ->
    lister.build './list_test', (err, list) ->
      assert.equal err, null
      expected =
        [
          {
            name: 'one.jpg'
            dir: 'list_test'
            path: 'list_test/one.jpg'
            type: 'image'
          }
          {
            name: 'sub'
            dir: 'list_test'
            path: 'list_test/sub'
            type: 'directory'
          }
          {
            name: 'two.jpg'
            dir: 'list_test'
            path: 'list_test/two.jpg'
            type: 'image'
          }
        ]
      assert.deepEqual list, expected
      done()

