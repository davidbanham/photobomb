fs = require 'fs'
querystring = require 'querystring'
path = require 'path'
findit = require 'findit'
mkdirp = require 'mkdirp'
http = require 'http'
director = require 'director'
templates = require './lib/templates.coffee'
thumbnailer = require './lib/thumbnailer.coffee'
DIR = './web'
THUMBDIR = './thumbs'
THUMBDIR = path.resolve THUMBDIR
DIR = path.resolve DIR
SIZES = [600, 1400]
mkdirp path.join(THUMBDIR, size.toString()) for size in SIZES
(findit.find(path.resolve(DIR))).on 'directory', (dir, stat) ->
  watchDir dir
hub = new (require('events')).EventEmitter
watchDir = (dir) ->
  (fs.watch dir).on 'change', (event, filename) ->
    console.log event, filename
    if event == 'rename' && filename
      fs.exists "#{dir}/#{filename}", (exists) ->
        return hub.emit "deleted", path.join(dir, filename) if !exists
        return hub.emit "created", path.join(dir, filename) if exists
watchDir DIR
hub.on 'created', (file) ->
  console.log "Created: ", file
  fs.stat file, (err, stats) ->
    watchDir file if stats.isDirectory()
  if path.extname(file) is '.jpg'
    thumbnailer.generate file, path.dirname(path.join(THUMBDIR, path.relative(DIR, file))), SIZES, (err) ->
      console.log "thumbs generated", err
hub.on 'deleted', (file) ->
  console.log "Deleted: ", file

router = new director.http.Router
  '/':
    get: ->
      templates 'index', {}, (err, content) =>
        if err?
          console.error err
          @res.statusCode = 500
          return @res.end()
        @res.end content
  '/error':
    get: ->
      @res.writeHead 500
      @res.end()
  '/:path':
    get: (path) ->
      console.log @qs
      templates path, {}, (err, content) =>
        if err?
          console.error err
          @res.statusCode = 500
          return @res.end()
        @res.end content

#router.attach ->
#  @qs = querystring.parse @req.url.split('?')[1]

server = http.createServer (req, res) ->
  router.dispatch req, res, (err) ->
    if err?
      res.writeHead 404
      res.end()

server.listen 8080
