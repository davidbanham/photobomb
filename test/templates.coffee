assert = require 'assert'
templates = require '../lib/templates.coffee'

describe 'templates', ->
  it 'should return a string', (done) ->
    templates 'gallery', {locals: items: []}, (err, content) ->
      assert typeof content == 'string'
      done()

  it 'should build a gallery page', (done) ->
    list =
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
    templates 'gallery', {locals: items: list}, (err, content) ->
      assert.equal err, null
      assert typeof content == 'string'
      done()
