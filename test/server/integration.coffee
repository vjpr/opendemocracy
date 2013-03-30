onelog = require 'onelog'
onelog.use onelog.Log4js
logger = require('onelog').get 'Test'

mongoose = require 'mongoose'

zombie = require 'zombie'
path = require 'path'
request = require 'supertest'
chai = require 'chai'
chai.should()
expect = require('chai').expect

config = require(path.join process.cwd(), '/config')('test')
liveApp = require('main/app')
# Runs full app on localhost.
liveApp.start()

describe 'Integration', ->

  before ->

  it 'homepage title is correct', (done) ->
    zombie.visit config.app.url, (e, browser) ->
      return done e if e
      browser.text('title').should.equal config.appPrettyName
      done()

  it 'homepage heading is correct', (done) ->
    zombie.visit config.app.url, (e, browser) ->
      return done e if e
      browser.query('h1').innerHTML.should.equal config.appPrettyName
      done()

  it 'if not logged in, user should be redirected to login page', (done) ->
    zombie.visit config.app.url + '/app', (e, browser) ->
      return done e if e
      browser.query('.lead').innerHTML.should.equal 'To begin, login with Facebook.'
      done()

  after ->
    mongoose.connection.close()
