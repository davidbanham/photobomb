fs = require 'fs'
path = require 'path'
EXTS = ['.jpg', '.jpeg']

module.exports =
  build: (parent, cb) ->
    list = []
    fs.readdir parent, (err, files) ->
      queue = files.length
      dir = (parent.split(path.sep).splice 3).join path.sep
      for file in files
        if file.charAt(0) is '.'
          queue--
          continue
        do (file) ->
          fs.stat path.join(parent, file), (err, stats) ->
            queue--
            info =
              name: file
              dir: dir
              path: path.join dir, file
            info.type = 'directory' if stats.isDirectory()
            info.type = 'image' if stats.isFile()
            if info.type is 'image'
              list.push info unless EXTS.indexOf(path.extname(file)) < 0
            list.push info if info.type is 'directory'
            cb null, list if queue == 0

  row: (list, length) ->
    rowed = []
    while list.length > 0
      rowed[rowed.length] = list.splice 0, length
    return rowed
