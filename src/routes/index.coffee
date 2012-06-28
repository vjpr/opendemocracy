class Routes

  constructor: ->

  index: (req, res) =>
    if not req.loggedIn
      res.render 'index'
    else
      res.render 'app'

exports.Routes = Routes
