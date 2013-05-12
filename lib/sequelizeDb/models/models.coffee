logger = require('onelog').get()
Sequelize = require 'sequelize'

module.exports = (sequelize) ->

  models = {}

  define = (name, args...) ->
    models[name] = sequelize.define name, args...
  int = Sequelize.INTEGER
  text = Sequelize.TEXT

  # Groups of initiatives.
  define 'issue',
      name: text

  define 'initiative',
      name: text

  define 'delegation',
      trusterId: int
      trusteeId: int
      unitId: int
      areaId: int
      issueId: int
      scope: Sequelize.ENUM ['unit', 'area', 'issue']

  define 'vote',
      issueId: int
      initiativeId: int
      memberId: int
      grade: int

  define 'unit',
      parentId: int
      active: Sequelize.BOOLEAN
      name: int
      description: int
      memberCount: int

  define 'area',
      unitId: int
      active: Sequelize.BOOLEAN
      name: text
      description: text
      directMemberCount: int
      memberWeight: int

  issueState = [
    'admission'
    'discussion'
    'verification'
    'voting'
    'canceled_revoked_before_accepted'
    'canceled_issue_not_accepted'
    'canceled_after_revocation_during_discussion'
    'canceled_after_revocation_during_verification'
    'canceled_no_initiative_admitted'
    'finished_without_winner'
    'finished_with_winner'
  ]

  define 'issue',
      areaId: int
      #policyId: int
      state: Sequelize.ENUM issueState
