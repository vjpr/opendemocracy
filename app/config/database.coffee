module.exports = (config) ->

  mongo:
    development:
      url: "mongodb://localhost/#{config.appName}"
    test:
      url: "mongodb://localhost/#{config.appName}-test"
    production:
      url: process.env.MONGOLAB_URI or process.env.MONGOHQ_URL

  redis:
    development:
      url: "localhost"
    production:
      url: process.env.REDISTOGO_URL
    test:
      url: "localhost"
