mkdirp = require 'mkdirp'
path = require 'path'
gm = require 'gm'
async = require 'async'

module.exports =
  delete: (filename, thumbdir, SIZES, cb) ->
    if path.extname(file) is '.jpg'
      for size in SIZES
        fs.unlink path.join(thumbdir, size, filename), (err) ->
           cb err if err?

  generate: (from, to, SIZES, cb) ->
    filename = path.basename from
    queue = async.queue @thumbnail, 1

    for size in SIZES
      queue.push {file: filename, size: size, to: to, from: from}, (err) ->
        throw err if err?

    queue.drain = ->
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
