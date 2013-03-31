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

config = require('config')('test')
LiveApp = require('main/app')

# Integration testing.
liveApp = LiveApp.start()
expressApp = liveApp.app
#expressApp = require('http').createServer LiveApp.app()

describe 'Unit', ->

  #before (done) ->
    # Wait for a mongodb connection before running tests.
    #mongoose.connection.on 'open', done

  it 'homepage should show', (done) ->
    request(expressApp).get('/').expect(200).end (e) ->
      return done e if e
      done()

describe 'Integration', ->

  before ->
    @browser = new zombie.Browser headers: accept: 'text/html'

  it 'homepage title is correct', (done) ->
    @browser.visit config.app.url, (e, browser) ->
      return done e if e
      browser.text('title').should.equal config.appPrettyName
      done()

  it 'homepage heading is correct', (done) ->
    @browser.visit config.app.url, (e, browser) ->
      return done e if e
      browser.query('h1').innerHTML.should.equal config.appPrettyName
      done()

  it 'if not logged in, user should be redirected to login page', (done) ->
    @browser.visit config.app.url + '/app', (e, browser) ->
      return done e if e
      browser.query('.lead').innerHTML.should.equal 'To begin, login with Facebook.'
      done()

  after ->
    mongoose.connection.close()
