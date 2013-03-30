config = require('config')()

# Short forms of all environments.
envs =
  'development': 'DEV'
  'production': 'PROD'
  'staging': 'STAGE'
  'test': 'TEST'

class @DefaultLogging

  @productionAppender:
    [
      {
        type: 'console'
        layout:
          type: 'colored'
          pattern: "%r #{envs[config.env]} ".grey + '[%p] - ' + '%c'.bold.cyan + ' - '
      },
    ]

  @developmentAppender:
    [
      {
        type: 'console'
        layout:
          type: 'colored'
          pattern: "%r #{envs[config.env]} ".grey + '[%-5p] - ' + '%c'.bold.cyan + ' - '
      },
    ]

  @devLevels:
    LiveFramework: 'DEBUG'
    Assets: 'INFO'
    'Assets:Mincer': 'ERROR'

  @prodLevels:
    Assets: 'ERROR'
