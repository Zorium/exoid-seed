_ = require 'lodash'
router = require 'exoid-router'

User = require '../models/user'
schemas = require '../schemas'

class UserCtrl
  getMe: ({}, {user}) ->
    User.sanitize(null, user)

module.exports = new UserCtrl()
