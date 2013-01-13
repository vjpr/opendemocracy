#= require underscore/underscore
#= require backbone/backbone
#= require jade-runtime
#= require_tree ./templates

# Workaround jade-runtime's use of `require`.
require = -> readFileSync: -> ''

$(document).ready ->
  console.log 'Loaded'
  # Client-side template functions are accessible as follows:
  # `JST['templates/home']()`
