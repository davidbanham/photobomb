# Photobomb

Photobomb takes a directory of images and turns it into a gallery on the web.

It watches that directory, so any new images get thumbnailed and served right away.

It preserves directory structure and allows arbitrary nesting.

Pages are responsive and should look great across desktop, tablet and mobile.

It's really simple for all users. The code is really straightforward, too.

It tries to be pretty.

All thumbnails are created at the time of image upload, so views are speedy.

## Screenshots

Take a look at the [blog post](https://blog.davidbanham.com/articles/photobomb/)

## Installation

If you like, you can just use the [Docker image](https://hub.docker.com/r/davidbanham/photobomb)

Your docker-compose.yml file could look like this:

```
  photobomb:
    restart: always
    image: davidbanham/photobomb
    ports:
      - "40009:3000"
    volumes:
       # Mount in the photos from your source dir
      - /tank/btsync/folders/photobomb:/opt/app/public/images
      
      # Mount in the cache directories
      - /tank/photobomb/data:/opt/app/data
      - /tank/photobomb/public:/opt/app/public
    environment:
      - FACEBOOK_APPID=OPTIONAL_SECRET_APPID_HERE
```

If you'd like to install it directly on an OS:

You'll need [nodeJS](https://nodejs.org/) and [GraphicsMagick](http://www.graphicsmagick.org/README.html) installed on your system. (on OSX you can just `brew install graphicsmagick`)

```
git clone https://github.com/davidbanham/photobomb.git
cd photobomb
node index.js
```

Shove some files in the `./public` directory.

Open a web browser and go to http://localhost:8080

For Upstart (Ubuntu) users there's a conf file included. Edit the paths as appropriate, pop that into `/etc/init/` and `sudo start photobomb` and you'll be away.

You can specify the following environment variables:

* PORT - The port the web server will listen on
* FACEBOOK_APPID - A Facebook App ID. If configured, Like and Share buttons will be added to your galleries.

## Usage

All you need to do is get your directories and image files into that public directory. I find the simplest way to do that is to use [BTSync](http://www.getsync.com/). You might also like [Dropbox](https://www.dropbox.com) or any number of other things.

With either of the mentioned tools, just install the client both on your devices (phone, etc) and your server.
When you put photos in the folder on your phone, they will automagically appear on the folder on your server.
When they do that, they will automagically appear on the iternet.

It's pretty great.
