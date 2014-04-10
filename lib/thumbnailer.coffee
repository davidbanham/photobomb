mkdirp = require 'mkdirp'
path = require 'path'
gm = require 'gm'
module.exports =
  delete: (filename, thumbdir, SIZES, cb) ->
    if path.extname(file) is '.jpg'
      for size in SIZES
        fs.unlink path.join(thumbdir, size, filename), (err) ->
           cb err if err?

  generate: (from, to, SIZES, cb) ->
    mkdirp to, (err) ->
      throw err if err?
      filename = path.basename from
      for size in SIZES
        do (size) ->
          mkdirp path.join(to, size.toString()), (err) ->
            gm(from)
              .resize(size)
              .write path.join(to, size.toString(), filename), (err) ->
                return cb err if err?
                cb null
