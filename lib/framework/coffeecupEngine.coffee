###
class CoffeecupEngine

Engine for the Coffeecup Template compiler. You will need `coffeecup`
Node module installed in order to use [[Mincer]] with `*.coffee` files:

npm install coffeecup

[[Template]]
###

"use strict"

# 3rd-party
coffeekup = undefined # initialized later
_ = require('underscore')

# internal
{Template} = require("mincer")

prop = require('mincer/lib/mincer/common').prop

#//////////////////////////////////////////////////////////////////////////////

# Class constructor
CoffeecupEngine = module.exports = CoffeecupEngine = ->
  Template.apply this, arguments

require("util").inherits CoffeecupEngine, Template

# Check whenever coffee-script module is loaded
CoffeecupEngine::isInitialized = ->
  !!coffeekup

# Autoload coffee-script library
CoffeecupEngine::initializeEngine = ->
  coffeekup = @require("coffeecup")

# Render data
CoffeecupEngine::evaluate = (context, locals, callback) ->
  try
    namespace = 'JST'
    tmpl = coffeekup.compile @data, locals
    out = """window.#{namespace}['#{context.logicalPath}'] =
#{tmpl.toString()}
"""
    callback null, out
  catch err
    callback err

# Expose default MimeType of an engine
prop CoffeecupEngine, 'defaultMimeType', 'application/javascript'
