path = require 'path'
fs = require 'fs'
director = require 'director'
templates = require '../lib/templates.coffee'
lister = require '../lib/lister.coffee'

build_gallery = (folder, that) ->
  lister.build folder, (err, tree) =>
    tree.sort (a, b) ->
      return 1 if a.type is 'image'
      return 0
    options =
      locals:
        items: tree
    templates 'gallery', options, (err, content) =>
      that.res.end content

module.exports = new director.http.Router
  '/':
    get: ->
      templates 'index', {}, (err, content) =>
        if err?
          console.error err
          @res.statusCode = 500
          return @res.end()
        @res.end content
  '/gallery':
    '/:sub':
      get: (sub) ->
        build_gallery path.join('web', sub), this
    get: ->
      build_gallery 'web', this
  '/thumbnails':
    '/(.*)':
      get: (item) ->
        file = fs.createReadStream(path.join 'thumbs', item)
        @res.writeHead 200, {
          "Content-Type": 'image/jpeg'
        }
        file.on 'error', =>
          @res.writeHead 404
          return @res.end 'Not Found'
        file.pipe @res
  '/images':
    '/(.*)':
      get: (item) ->
        file = fs.createReadStream(path.join 'web', item)
        @res.writeHead 200, {
          "Content-Type": 'image/jpeg'
        }
        file.on 'error', =>
          @res.writeHead 404
          return @res.end 'Not Found'
        file.pipe @res
  '/assets':
    '/:file':
      get: (file) ->
        fs.createReadStream(path.join 'assets', file).pipe @res
  '/error':
    get: ->
      @res.writeHead 500
      @res.end()
      #  '/:path':
      #    get: (path) ->
      #      console.log "@qs is", @qs
      #      templates path, {}, (err, content) =>
      #        if err?
      #          console.error err
      #          @res.statusCode = 500
      #          return @res.end()
      #        @res.end content
.configure {recurse: false, strict: false}
#router.attach ->
#  @qs = querystring.parse @req.url.split('?')[1]
