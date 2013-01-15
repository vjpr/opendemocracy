onelog = require 'onelog'
onelog.use onelog.Log4js
logger = require('onelog').get 'Test'

chai = require 'chai'
chai.should()

describe 'Server', ->
  it 'should work', ->
