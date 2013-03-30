class TestController

  @allTests: (req, res) ->
    res.render process.cwd() + '/test/client/views/test'

module.exports = TestController
