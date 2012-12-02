# Express Bootstrap

I use this for every new Express project.

## Setup

    heroku apps:create yourappname

### If you want Facebook Authentication

Add to `/etc/hosts`

    127.0.0.1    localhost.yourappname.herokuapp.com

Create app at <https://developers.facebook.com/apps>

Fill in the following details at the bottom of the page. (They are hidden by default)

    Site URL: http://yourappname.herokuapp.com/
    App Domains:
      - localhost.yourappname.herokuapp.com
      - yourappname.herokuapp.com

Paste `siteUrl`, `appId` and `appSecret` into `src/model.coffee` (See TODOs)

Create a new Mongo database and modify the appropriate line in `src/model.coffee`

Visit <http://localhost:3030/>

## Install

    npm install nodemon -g
    npm install

## Dev

    make
    
Visit <http://localhost:3030>

## Debug

See <https://github.com/dannycoates/node-inspector>

    node --debug-brk app
    node-inspector &
    
 Visit <http://127.0.0.1:8080/debug?port=5858>
 
## TODO
