assert = require 'assert'
templates = require '../lib/templates.coffee'
describe 'templates', ->
  it 'should return a string', (done) ->
    templates 'index', {}, (err, content) ->
      assert typeof content == 'string'
      done()
