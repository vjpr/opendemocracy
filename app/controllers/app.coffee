class AppController

  @index: (req, res) =>
    res.render 'index'

  @app: (req, res) =>
    unless req.user
      res.render 'login'
    else
      res.render 'app', user: req.user

module.exports = AppController
