# Express Bootstrap

I use this for every new Express project.

## Setup

### If you want Facebook Authentication

Add to `/etc/hosts`

    127.0.0.1    localhost.yourappname.herokuapps.com

Create app at <https://developers.facebook.com/apps>

    Site URL: http://yourappname.herokuapps.com/
    Site Domain: localhost.yourappname.herokuapps.com

Paste `siteUrl`, `appId` and `appSecret` into `src/model.coffee` (See TODOs)

Create a new Mongo database and modify the appropriate line in `src/model.coffee`

Visit <http://localhost:3030/app>

## Install

    npm install supervisor -g

## Dev

    ./run
    
Visit <http://localhost:3030>

## Debug

See <https://github.com/dannycoates/node-inspector>

    node --debug-brk app
    node-inspector &
    
 Visit <http://127.0.0.1:8080/debug?port=5858>
 
## TODO

 - Zappa
 