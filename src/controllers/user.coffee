_ = require 'lodash'
router = require 'exoid-router'

User = require '../models/user'
schemas = require '../schemas'

class UserCtrl
  getMe: ({}, {userId}) ->
    User.getById userId
    .then User.sanitize(userId)

module.exports = new UserCtrl()
