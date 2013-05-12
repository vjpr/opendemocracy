Faker = require 'Faker'
uuid = require 'node-uuid'
bcrypt  = require 'bcrypt'

GitHubApi = require 'github'

github = new GitHubApi
  version: '3.0.0'
  timeout: 5000

getGitHubUsers = (done) ->

  github.authenticate
    type: 'basic'
    username: process.env['GITHUB_USERNAME']
    password: process.env['GITHUB_PASSWORD']

  await github.user.getFollowers {user: 'jashkenas'}, defer e, users
  return done e if e
  done users

randomlyDelegateVotesForUsersByInitiative = ->

@generateUsers = ->


# Seed database with users.
@run = (models, done) ->

  generatePasswordHash = (password) ->
    salt = bcrypt.genSaltSync 10
    hash = bcrypt.hashSync password, salt
    [hash, salt]

  # Create test user.
  [hash, salt] = generatePasswordHash 'test'
  models.User.create
    name: 'Vaughan'
    email: 'vrouesnel@gmail.com'
    password: hash
    salt: salt

  for i in [0..10]
    models.User.create
      #id: uuid.v4()
      name: Faker.Name.findName()
