# TODO: Cakefile

# TODO: `assets:precompile`

config = require('config')()
require('config/logging')()
logger = require('onelog').get 'Cakefile'

task 'db:seed', 'prepare db with test fixtures', ->
  db = require 'sequelizeDb'
  await db.init defer e, sequelize
  throw e if e
  await db.seed defer e
  throw e if e

task 'db:sync', 'prepare db', ->
  await require('sequelizeDb').sync defer e
  throw e if e
