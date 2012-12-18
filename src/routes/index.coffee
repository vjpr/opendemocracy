class Routes

  constructor: ->

  index: (req, res) =>
    res.render 'index'

  app: (req, res) =>
    unless req.user
      res.render 'login'
    else
      console.log req.user
      res.render 'app', user: req.user

exports.Routes = Routes
