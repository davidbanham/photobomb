assert = require 'assert'
lister = require '../lib/lister'
templates = require '../lib/templates.coffee'
describe 'templates', ->
  it 'should return a string', (done) ->
    templates 'index', {}, (err, content) ->
      assert typeof content == 'string'
      done()

  it 'should build a gallery page', (done) ->
    lister.build './web/wat', (err, list) ->
      assert.equal err, null
      templates 'gallery', {locals: items: list}, (err, content) ->
        assert.equal err, null
        assert typeof content == 'string'
        done()
