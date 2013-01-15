onelog = require 'onelog'
onelog.use onelog.Log4js
logger = require('onelog').get 'Test'

request = require 'supertest'
chai = require 'chai'
chai.should()

config = require(process.cwd() + '/src/config')('test')
app = require(process.cwd() + '/src/app').app()
server = require('http').createServer app

describe 'Server', ->
  it 'should work', (done) ->
    request(server).get('/').expect(200).end (err) ->
      throw err if err
      done()
