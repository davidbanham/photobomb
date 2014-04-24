fs = require 'fs'
querystring = require 'querystring'
path = require 'path'
findit = require 'findit'
mkdirp = require 'mkdirp'
http = require 'http'
findit = require 'findit'
templates = require './lib/templates.coffee'
thumbnailer = require './lib/thumbnailer.coffee'
watcher = require './lib/watcher.coffee'
router = require './lib/router.coffee'
lister = require './lib/lister.coffee'

DIR = './public/images'
THUMBDIR = './thumbs'
THUMBDIR = path.resolve THUMBDIR
DIR = path.resolve DIR
SIZES = [600, 1400]
EXTS = ['.jpg', '.jpeg']

mkdirp path.join(THUMBDIR, size.toString()) for size in SIZES

#Watch all subdirectories of the main dir
(findit.find(path.resolve(DIR)))
  .on 'directory', (dir, stat) ->
    watcher.watch dir
  #Create a thumbnail for every file we find
  .on 'file', (file) ->
    thumbnail_file file

#Also watch the top level dir
watcher.watch DIR

#Build index page
lister.build DIR, (err, list) ->
  list = lister.row list, 4
  templates 'gallery', {locals: items: list}, (err, content) ->
    fs.writeFile "./public/index.html", content

watcher.on 'created', (file) ->
  console.log "Created: ", file
  fs.stat file, (err, stats) ->
    watchDir file if stats.isDirectory()
  thumbnail_file file if EXTS.indexOf(path.extname(file)) > -1

thumbnail_file = (file) ->
  console.log 'thumbnailing', file
  thumbnailer.generate file, path.dirname(path.join(THUMBDIR, path.relative(DIR, file))), SIZES, (err) ->
    target_dir = path.dirname path.relative DIR, file
    lister.build "./public/images/#{target_dir}", (err, list) ->
      return console.error err if err?
      list = lister.row list, 4
      templates 'gallery', {locals: items: list}, (err, content) ->
        fs.writeFile "./public/#{target_dir}.html", content

watcher.on 'deleted', (file) ->
  console.log "Deleted: ", file

server = http.createServer (req, res) ->
  router.dispatch req, res, (err) ->
    if err?
      res.writeHead 404
      res.end()

server.listen 8080
