class Routes

  constructor: ->

  index: (req, res) =>
    res.render 'index'

  app: (req, res) =>
    if not req.loggedIn
      res.render 'login'
    else
      res.render 'app'

exports.Routes = Routes
