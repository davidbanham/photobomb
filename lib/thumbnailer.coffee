mkdirp = require 'mkdirp'
path = require 'path'
gm = require 'gm'
async = require 'async'
crypto = require 'crypto'
levelup = require 'level'
fs = require 'fs'
equal = require 'deep-equal'

store = levelup 'data/thumbcache'

module.exports =
  delete: (filename, thumbdir, SIZES, cb) ->
    if path.extname(file) is '.jpg'
      for size in SIZES
        fs.unlink path.join(thumbdir, size, filename), (err) ->
           cb err if err?

  generate: (from, to, SIZES, cb) ->
    @check_cache from, to, SIZES, (err, cached) =>
      return cb err if err?
      return cb null if cached

      filename = path.basename from
      queue = async.queue @thumbnail, 1

      for size in SIZES
        queue.push {file: filename, size: size, to: to, from: from}, (err) ->
          throw err if err?

      queue.drain = =>
        @cache from, SIZES, (err) ->
          throw err if err?
          cb null

  thumbnail: (input, cb) ->
    file = input.file
    size = input.size
    to = input.to
    from = input.from

    mkdirp path.join(to, size.toString()), (err) ->
      gm(from)
        .resize(size)
        .write path.join(to, size.toString(), file), (err) ->
          return cb err if err?
          cb null

  cache: (file, SIZES, cb) ->
    @hash file, (err, hash) ->
      return cb err if err?
      doc = JSON.stringify
        hash: hash
        sizes: SIZES
      store.put file, doc, (err) ->
        cb err

  check_cache: (file, thumbdir, SIZES, cb) ->
    queue = async.queue
    checks = []
    for size in SIZES
      checks.push (cb) ->
        fs.exists path.join(thumbdir, size.toString(), path.basename file), (exists) ->
          cb null, exists

    async.parallel checks, (err, results) =>
      return cb(null, false) if results.indexOf false > -1

      @hash file, (err, hash) ->
        return cb err if err?
        store.get file, (err, str) ->
          return cb null, false if err?.notFound?
          return cb err if err?
          doc = JSON.parse str
          return cb(null, true) if doc.hash is hash and equal(doc.sizes, SIZES)
          return cb null, false

  hash: (file, cb) ->
    fs.readFile file, (err, data) ->
      return cb err if err?
      md5sum = crypto.createHash 'md5'
      md5sum.update data
      cb null, md5sum.digest('hex')

