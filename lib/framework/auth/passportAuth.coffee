logger          =  require('onelog').get 'Auth'
passport        = require 'passport'
LocalStrategy   = require('passport-local').Strategy
FacebookStrategy = require('passport-facebook').Strategy
mongoose        = require 'mongoose'
config          = require('config')()
bcrypt          = require 'bcrypt'
_               = require 'underscore'

#User = mongoose.model 'User'
User = require 'services/userService'

settings =
  common:
    getLogoutPath: '/logout'
    logoutSuccessRedirect: '/'

  facebook:
    scope: 'email'
    myHostname: config.app.url
    appId: config.credentials.fb.appId
    appSecret: config.credentials.fb.appSecret
    redirectPath: '/app'

  password:
    getLoginPath: '/login'
    postLoginPath: '/login'
    loginView: 'login.jade'
    getRegisterPath: '/register'
    postRegisterPath: '/register'
    registerView: 'register.jade'
    loginSuccessRedirect: '/app'
    registerSuccessRedirect: '/app'
    loginFormFieldName: 'username'
    passwordFormFieldName: 'password'

allowedUserFields = 'id name email fb'

# Provides functionality to support Passport.
class PassportSupport

  constructor: (@db) ->

    passport.use new FacebookStrategy
      clientID: config.credentials.fb.appId
      clientSecret: config.credentials.fb.appSecret
      callbackURL: "#{config.app.url}/auth/facebook/callback"
      passReqToCallback: true
    , (req, accessToken, refreshToken, profile, done) ->
      User.findOrCreate profile, (err, user) ->
        return done err if err
        req.session.fbAccessToken = accessToken
        done null, user

    passport.use new LocalStrategy
      usernameField: 'username'
      passwordField: 'password'
    , @authenticate

    passport.serializeUser @serialize
    passport.deserializeUser @deserialize

  # Used by Passport to authenticate login requests.
  authenticate: (email, password, done) =>
    logger.debug "Authentication starting now"
    User.findOne {email}, allowedUserFields, (err, user) ->
      if err
        logger.debug "Authentication failed: Server error:", err
        return done err
      unless user
        message = "User not found."
        logger.debug "Authentication failed: #{message}"
        return done null, false, {message}
      unless user.validatePassword password
        message = "Incorrect password."
        logger.debug "Authentication failed: #{message}"
        return done null, false, {message}
      else
        logger.debug "Authentication successful:", user
        return done null, user

  serialize: (user, done) =>
    done null, user.id

  deserialize: (id, done) =>
    unless id
     return done "No user id stored in session"
    User.findById id, allowedUserFields, (err, user) -> done err, user

# Authentication routes for login, logout, registration.
class AuthController

  constructor: ->
    @passportSupport = new PassportSupport

  setupMiddleware: (app) ->
    app.use passport.initialize()
    app.use passport.session()
    app.use (req, res, next) ->
      res.locals.user = req.user
      next()

  setupRoutes: (app) ->

    # Password
    # --------

    app.get settings.password.getLoginPath, (req, res) ->
      res.render settings.password.loginView

    app.post settings.password.postLoginPath,
      passport.authenticate 'local',
        successRedirect: settings.password.loginSuccessRedirect
        failureRedirect: settings.password.getLoginPath
        failureFlash: true

    app.get settings.common.getLogoutPath, (req, res) ->
      req.logout()
      res.redirect settings.common.logoutSuccessRedirect

    app.get settings.password.getRegisterPath, (req, res) ->
      res.render settings.password.registerView

    app.post settings.password.postRegisterPath, (req, res, next) ->
      # Validation
      req.assert('name', "Name can't be empty.").notEmpty()
      req.assert(settings.password.loginFormFieldName, "Must use a valid email.").isEmail()
      req.assert(settings.password.passwordFormFieldName, "Password must be at least 6 characters.").len(6)
      errors = req.validationErrors()
      if errors
        req.flash 'error', _.pluck errors, 'msg'
        return res.redirect settings.password.getRegisterPath

      generatePasswordHash = (password) ->
        salt = bcrypt.genSaltSync 10
        hash = bcrypt.hashSync password, salt
        [hash, salt]
      name = req.body?.name
      email = req.body?[settings.password.loginFormFieldName]
      password = req.body?[settings.password.passwordFormFieldName]
      User.findOne {email}, allowedUserFields, (err, user) ->
        return next err if err
        if user
          req.flash 'error', ["User already exists."]
          return res.redirect settings.password.getRegisterPath
        [hash, salt] = generatePasswordHash password
        newUser =
          name: name
          email: email
          password: hash
          salt: salt
        User.create newUser, (err, user) ->
          if err
            logger.error "Registration failed:", err
            return next err if err
          logger.debug "Registration succeeded:", user.name, user.email
          req.login user, (err) ->
            return next err if err
            res.redirect settings.password.registerSuccessRedirect

    # Facebook
    # --------

    app.get "/auth/facebook", passport.authenticate 'facebook', scope: 'email'

    app.get "/auth/facebook/callback",
      passport.authenticate 'facebook',
        successRedirect: settings.facebook.redirectPath
        failureRedirect: settings.password.getLoginPath

module.exports = AuthController
