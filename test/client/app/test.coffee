#= require jquery/jquery
#= require mocha/mocha.js
#= require chai
#= require sinon
#= require sinon-chai

should = chai.Should()
expect = chai.expect
mocha.setup
  ui: 'bdd'
  globals: []
  ignoreLeaks: true

describe 'Client', ->
  it 'should work', ->
