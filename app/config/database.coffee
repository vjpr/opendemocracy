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

  mysql:
    development:
      name: 'expressbootstrap'
      username: 'root'
      password: null
    test:
      name: 'expressbootstrap-test'
      username: 'root'
      password: null
    production:
      name: 'expressbootstrap'
      host: 'localhost'
      port: 3306
