fs = require 'fs'
querystring = require 'querystring'
path = require 'path'
findit = require 'findit'
mkdirp = require 'mkdirp'
findit = require 'findit'
static_ = require 'node-static'
templates = require './lib/templates.coffee'
thumb_stream = require './lib/thumb_stream.coffee'
generator = thumb_stream.generate()
watcher = require './lib/watcher.coffee'
lister = require './lib/lister.coffee'

DIR = './public/images'
THUMBDIR = './public/thumbs'
THUMBDIR = path.resolve THUMBDIR
SIZES = [600, 1400]
FACEBOOK_APPID = process.env.FACEBOOK_APPID
EXTS = ['.jpg', '.jpeg']

mkdirp path.join(THUMBDIR, size.toString()) for size in SIZES

#Watch all subdirectories of the main dir
(findit.find(path.resolve(DIR)))
  .on 'directory', (dir, stat) ->
    return if dir.charAt(0) is '.'
    return if dir.indexOf('SyncArchive') > -1
    watcher.watch dir
    build_gallery path.relative DIR, dir
  #Create a thumbnail for every file we find
  .on 'file', (file) ->
    return if file.charAt(0) is '.'
    thumbnail_file file if EXTS.indexOf(path.extname(file).toLowerCase()) > -1

#Also watch the top level dir
watcher.watch DIR

#Build index page
lister.build DIR, (err, list) ->
  list = lister.row list, 4
  templates 'gallery', {locals: items: list, facebook_appid: FACEBOOK_APPID}, (err, content) ->
    fs.writeFile "./public/index.html", content

watcher.on 'created', (file) ->
  return if file.charAt(0) is '.'
  console.log "Created: ", file
  fs.stat file, (err, stats) ->
    watchDir file if stats.isDirectory()
  thumbnail_file file if EXTS.indexOf(path.extname(file).toLowerCase()) > -1
  build_gallery path.dirname path.relative DIR, file if EXTS.indexOf(path.extname(file).toLowerCase()) > -1

thumbnail_file = (file) ->
  generator.write
    from: file
    to: path.dirname(path.join(THUMBDIR, path.relative(DIR, file)))
    sizes: SIZES

build_gallery = (target_dir) ->
  lister.build "./public/images/#{target_dir}", (err, list) ->
    return console.error err if err?
    list = lister.row list, 4
    templates 'gallery', {locals: title: target_dir, items: list, facebook_appid: FACEBOOK_APPID}, (err, content) ->
      mkdirp "./public/#{target_dir}", (err) ->
        fs.writeFile "./public/#{target_dir}/index.html", content
        console.log 'gallery written for', target_dir

watcher.on 'deleted', (file) ->
  console.log "Deleted: ", file

file = new static_.Server("./public")

require("http").createServer((request, response) ->
  request.addListener("end", ->
    file.serve request, response
  ).resume()
).listen process.env.PORT or 8080
