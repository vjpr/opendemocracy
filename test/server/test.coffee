onelog = require 'onelog'
onelog.use onelog.Log4js
logger = require('onelog').get 'Test'

request = require 'supertest'
chai = require 'chai'
chai.should()

config = require(process.cwd() + '/app/config')('test')
app = require(process.cwd() + '/app/app').app()
server = require('http').createServer app

describe 'Server', ->
  it 'should work', (done) ->
    request(server).get('/').expect(200).end (err) ->
      throw err if err
      done()
