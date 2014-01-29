fs = require 'fs'
path = require 'path'
jade = require 'jade'
files = {}
DIR = path.join __dirname, '..', 'templates'
cache = {}

module.exports = (name, opts, cb) ->
  name += '.jade'
  return cb null, jade.compile(cache[name], opts)(opts.locals) if cache[name]?
  fs.readFile path.join(DIR, name), (err, content) ->
    return cb err if err?
    cache[name] = content.toString()
    cb null, jade.compile(cache[name], opts)(opts.locals)
