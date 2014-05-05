fs = require 'fs'
path = require 'path'
EXTS = ['.jpg', '.jpeg']

module.exports =
  build: (parent, cb) ->
    list = []
    fs.readdir parent, (err, files) ->
      files = files.filter (file) ->
        return false if file.charAt(0) is '.'
        return true
      queue = files.length
      dir = (parent.split(path.sep).splice 3).join path.sep
      for file in files
        do (file) ->
          fs.stat path.join(parent, file), (err, stats) ->
            info =
              name: file
              dir: dir
              path: path.join dir, file
            info.type = 'directory' if stats.isDirectory()
            info.type = 'image' if stats.isFile()
            if info.type is 'image'
              queue--
              list.push info unless EXTS.indexOf(path.extname(file).toLowerCase()) < 0
              cb null, list if queue is 0
            else
              fs.readdir path.join(parent, info.path), (err, files) ->
                queue--
                if (files.length is 0) or (!files)
                  cb null, list if queue is 0
                  return
                info.title_card = files.filter((file) ->
                  return false if file.charAt(0) is '.'
                  return true
                )[0]
                list.push info
                cb null, list if queue is 0

  row: (list, length) ->
    rowed = []
    while list.length > 0
      rowed[rowed.length] = list.splice 0, length
    return rowed
