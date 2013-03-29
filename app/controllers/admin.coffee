@index = (req, res) ->
  return res.redirect '/login' unless req.user?
  res.render 'admin/index',
    user: req.user
