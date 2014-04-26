thumbnailer = require '../lib/thumbnailer.coffee'
t2 = require 'through2'

ThumbStream = ->
  return this

ThumbStream.prototype.generate = ->
  return t2.obj (data, enc, cb) ->
    thumbnailer.generate data.from, data.to, data.sizes, (err) =>
      @emit err if err?
      @push data
      cb()

module.exports = new ThumbStream
