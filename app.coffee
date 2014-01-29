fs = require 'fs'
querystring = require 'querystring'
path = require 'path'
findit = require 'findit'
mkdirp = require 'mkdirp'
http = require 'http'
findit = require 'findit'
thumbnailer = require './lib/thumbnailer.coffee'
watcher = require './lib/watcher.coffee'
router = require './lib/router.coffee'

DIR = './web'
THUMBDIR = './thumbs'
THUMBDIR = path.resolve THUMBDIR
DIR = path.resolve DIR
SIZES = [600, 1400]
EXTS = ['.jpg', '.jpeg']

mkdirp path.join(THUMBDIR, size.toString()) for size in SIZES

#Watch all subdirectories of the main dir
(findit.find(path.resolve(DIR))).on 'directory', (dir, stat) ->
  watcher.watch dir

#Also watch the top level dir
watcher.watch DIR

watcher.on 'created', (file) ->
  console.log "Created: ", file
  fs.stat file, (err, stats) ->
    watcher.watch file if stats.isDirectory()
  if EXTS.indexOf(path.extname(file)) > -1
    thumbnailer.generate file, path.dirname(path.join(THUMBDIR, path.relative(DIR, file))), SIZES, (err) ->
      console.log "thumbs generated", err

watcher.on 'deleted', (file) ->
  console.log "Deleted: ", file

server = http.createServer (req, res) ->
  router.dispatch req, res, (err) ->
    if err?
      res.writeHead 404
      res.end()

server.listen 8080
