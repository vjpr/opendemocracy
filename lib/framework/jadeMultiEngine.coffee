## class JadeMultiEngine
#
# Engine which compiles a single Jade file into a set of JST templates for client-side use.
#
#
# Subclass of [[Template]]
#

## Imports
_ = require 'underscore'
Mincer = require 'mincer'
util = require 'util'
async = require 'async'
coffeeScript = require 'coffee-script'
Jade = require 'jade'
logger = require('onelog').get('JadeMultiEngine')
async = require 'async'
fs = require 'fs'

prop = require('mincer/lib/mincer/common').prop

## Initialization

JadeMultiEngine = module.exports = -> Mincer.Template.apply(@, arguments)
util.inherits JadeMultiEngine, Mincer.Template

## JST Namespacing configuration.
namespace = 'this.JST'
JadeMultiEngine.setNamespace = (value) -> namespace = value

## Helpers

convertToJST = (name, template, callback) ->
  callback null,
    """
    (function () {
      #{namespace} || (#{namespace} = {});
      #{namespace}['#{name}'] = #{template.replace(/$(.)/mg, '$1 ').trimLeft().trimRight()}
    }).call(this);
    """

compileJade = (data, context, callback) ->
  try
    result = Jade.compile data, _.extend({}, {
      client: true
      filename: context.pathname
    })

    callback null, result.toString()
  catch err
    callback err

compileTemplate = (name, template, context) ->
  (callback) ->
    compileJade template, context, (err, template) ->
      return callback(err) if err?
      convertToJST name, template, callback


calculateIndentLevel = (line) -> line.match(/^(\t| )*/)[0].length

removeExcessIndents = (lines) ->
  level = calculateIndentLevel(lines[0])
  for line in lines
    # Ignore empty or partially indented blank lines.
    if _.isEmpty(line.trim()) then "" else line[level ..]


subTemplateRegex = /^(\t| )*\/\/- \[([a-zA-Z0-9._-]*)\]/
#subTemplateRegex = /^(\t| )*\\.sub-template \[([a-zA-Z0-9._-]+)\]/

## createTemplate
#     - currentIdx is the current index that we are processing.
#     - lines is the array of all lines in the multi-template
#     - templates is an object containing completed templates (non-relative names).
createTemplate = (currentIdx, lines, templates) ->
  # Calculate the current base level of the template.
  templateBaseLevel = calculateIndentLevel(lines[currentIdx])
  name = lines[currentIdx].match(subTemplateRegex)[2]

  templateLines = [ lines[currentIdx] ]
  currentIdx += 1

  return currentIdx if name is ''

  # Helper function that processes and adds the template.
  finalizeTemplate = ->
    throw "Duplicate template named: #{name}" if templates[name]?
    templates[name] = removeExcessIndents(templateLines).join("\n")
    return

  # Checks:
  #   - if we are within the lines array;
  #   - if we are still at the right indent level;
  while currentIdx < lines.length and (calculateIndentLevel(lines[currentIdx]) >= templateBaseLevel or _.isEmpty(lines[currentIdx].trim()))
    # Check if a new template has been started.
    if lines[currentIdx].match(subTemplateRegex)?
      if calculateIndentLevel(lines[currentIdx]) is templateBaseLevel
        # If its at the same level we start a new template outside and quit after its done.
        finalizeTemplate()
        return createTemplate(currentIdx, lines, templates)
      else
        # If its within the current template's block we continue processing after its done.
        currentIdx = createTemplate(currentIdx, lines, templates)
    else
      # Since a new template hasn't been created we continue processing.
      templateLines.push(lines[currentIdx])
      currentIdx += 1

  # We have gotten to the end of the file or to the end of the template block.
  # So we finalise the template and return the currentIdx.
  finalizeTemplate()
  return currentIdx

## Render
JadeMultiEngine::evaluate = (context, locals, callback) ->
  lines = @data.split "\n"

  templates = {}

  # Contains lines of the outer/wrapping template
  mainTemplateLines = []

  currentIdx = 0
  while currentIdx < lines.length
    line = lines[currentIdx]
    # If its the start of the template - delegate processing.
    if line.match(subTemplateRegex)?
      currentIdx = createTemplate(currentIdx, lines, templates)
    else
      mainTemplateLines.push(line)
      currentIdx += 1

  # Stores the properly named templates
  namedTemplates = {}
  namedTemplates[context.logicalPath] = mainTemplateLines.join("\n")
  for name, template of templates
    namedTemplates["#{context.logicalPath}/#{name}"] = template

  async.parallel (compileTemplate(name, template, context) for name, template of namedTemplates), (err, templates) ->
    if err?
      logger.error "Compiling #{context.logicalPath}", err
      return callback err


    callback null, templates.join "\n"

# Expose the MimeType of the engine.
prop(JadeMultiEngine, 'defaultMimeType', 'application/javascript');
