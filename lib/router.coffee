director = require 'director'
templates = require '../lib/templates.coffee'
lister = require '../lib/lister.coffee'

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
        console.log "sub is", sub
    get: ->
      lister.build "web", (err, tree) =>
        options =
          locals:
            items: tree
        templates 'gallery', options, (err, content) =>
          console.log "about to send", content
          @res.end content

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
