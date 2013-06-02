mkdirp = require 'mkdirp'
gm = require 'gm'
module.exports =
  delete: (filename, thumbdir, SIZES, cb) ->
    if path.extname(file) is '.jpg'
      for size in SIZES
        fs.unlink path.join(thumbdir, size, filename), (err) ->
           cb err if err?

  generate: (from, to, SIZES, cb) ->
    console.log "Got thumb request", from, to
    mkdirp to, (err) ->
      return console.log err if err?
      filename = path.basename from
      for size in SIZES
        do (size) ->
          mkdirp path.join(to, size.toString()), (err) ->
            console.log "acting for ", size
            console.log path.join(to, size.toString(), filename)
            gm(from)
              .resize(size)
              .write path.join(to, size.toString(), filename), (err) ->
                console.log "finished with ", null
                return cb err if err?
                cb null
