onelog = require 'onelog'
onelog.use onelog.Log4js
logger = require('onelog').get 'Test'

describe 'Server', ->
  it 'should work', ->
