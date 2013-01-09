# Express Bootstrap

I use this for every new Express project.

## Checkout

  mkdir yourappname
  cd yourappname
  git clone https://github.com/vjpr/express-bootstrap.git .

If using IntelliJ, `File > Open...` and select `yourappname` dir you just created.

Create a repo on GitHub for `yourappname`.

  git remote rename origin bootstrap
  git remote add origin <remote-github-url>

### Live Reload

Add `yourappname` folder as a monitored folder in LiveReload. Exclude the `src` directory.

## Setup

    heroku apps:create yourappname
    heroku addons:add mongolab:starter
    heroku addons:add redistogo:nano
    heroku config:add NODE_ENV=production

See https://devcenter.heroku.com/articles/nodejs for more.

### If you want Facebook Authentication

Add to `/etc/hosts`

    127.0.0.1    localhost.yourappname.herokuapp.com

Create app at <https://developers.facebook.com/apps>

Fill in the following details at the bottom of the page.

    Website with Facebook login > Site URL: http://yourappname.herokuapp.com/
    App Domains:
      - localhost.yourappname.herokuapp.com
      - yourappname.herokuapp.com

Paste `appId` and `appSecret` into `src/config.coffee`.

Modify `appName` in `src/config.coffee` to your Heroku app name.

Modify `name` in `package.json`.

Install with `npm install`, then run `make`.

Install vendor libraries with Bower: `bower install`. (This will be slow the
first time you run it because the libraries are not cached yet.)

Visit <http://localhost:3030/>

## Install

Make sure you are using Node 0.8.x.

    npm install nodemon -g
    npm install
    npm install bower -g
    bower install

## Dev

    make
    
Visit <http://localhost:3030>

## Debug

See <https://github.com/dannycoates/node-inspector>

    node --debug-brk app
    node-inspector &
    
 Visit <http://127.0.0.1:8080/debug?port=5858>

## Deploy

### Heroku

  git push heroku master

### EC2

*Coming soon using Chef...*

## TODO

- EC2 deploy using Chef.
- LiveReload built in.
