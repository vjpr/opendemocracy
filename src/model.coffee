mongoose = require 'mongoose'
mongooseAuth = require 'mongoose-auth'
everyauth = require 'everyauth'
everyauth.debug = true

Schema = mongoose.Schema

class Model

  constructor: ->

    UserSchema = new Schema {}

    # TODO: Change myHostname, appId, appSecret
    UserSchema.plugin mongooseAuth,
      everymodule:
        everyauth:
          User: =>
            return @User

      facebook:
        everyauth:
          scope: 'read_mailbox, email'
          myHostname: 'http://localhost.[appname].herokuapps.com:3020'
          appId: '[appId]'
          appSecret: '[appSecret]'
          redirectPath: '/'

    @User = mongoose.model 'User', UserSchema

    # TODO: Change mongodb name
    mongoose.connect 'mongodb://localhost/[appname]'

exports.Model = Model
