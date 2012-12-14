mongoose = require 'mongoose'
mongooseAuth = require 'mongoose-auth'
everyauth = require 'everyauth'
config = require('./config')()

everyauth.debug = true

Schema = mongoose.Schema

class Model

  constructor: ->

    UserSchema = new Schema {}

    UserSchema.plugin mongooseAuth,
      everymodule:
        everyauth:
          User: =>
            return @User

      facebook:
        everyauth:
          scope: 'email'
          myHostname: config.app.url
          appId: config.fb.appId
          appSecret: config.fb.appSecret
          redirectPath: '/app'

      password:
        loginWith: 'email'
        everyauth:
          getLoginPath: '/login'
          postLoginPath: '/login'
          loginView: 'login.jade'
          getRegisterPath: '/register'
          postRegisterPath: '/register'
          registerView: 'register.jade'
          loginSuccessRedirect: '/app'
          registerSuccessRedirect: '/'
          loginLocals:
            title: 'Eli'
            everyauth: everyauth
            email: ''
          registerLocals:
            title: 'Eli'
            everyauth: everyauth
            email: ''
          loginFormFieldName: 'email'

    @User = mongoose.model 'User', UserSchema

    mongoose.set 'debug', true
    # TODO: Change mongodb name
    mongoose.connect config.mongo.url
    mongoose.connection.on 'error', (err) =>
      console.error "Connection error: " + err
    mongoose.connection.on 'open', ->
      console.log "Connected!"

exports.Model = Model
