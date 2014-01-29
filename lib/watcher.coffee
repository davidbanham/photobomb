fs = require 'fs'
path = require 'path'

Stream = require('stream').Stream

Watcher = ->
  return this

Watcher.prototype = new Stream

Watcher.prototype.watch = (dir) ->
  (fs.watch dir).on 'change', (event, filename) =>
    console.log event, filename
    if event == 'rename' && filename
      fs.exists "#{dir}/#{filename}", (exists) =>
        return @emit "deleted", path.join(dir, filename) if !exists
        return @emit "created", path.join(dir, filename) if exists

module.exports = new Watcher()
