_ = require 'lodash'
uuid = require 'node-uuid'

r = require '../services/rethinkdb'
config = require '../../config'

USERS_TABLE = 'users'

defaults = (user) ->
  unless user?
    return null

  _.assign {
    id: uuid.v4()
  }, user

class UserModel
  RETHINK_TABLES: [
    {
      name: USERS_TABLE
    }
  ]

  create: (user) ->
    user = defaults user

    r.table USERS_TABLE
    .insert user
    .run()
    .then ->
      user

  getById: (id) ->
    r.table USERS_TABLE
    .get id
    .run()
    .then defaults

  updateById: (id, diff) ->
    r.table USERS_TABLE
    .get id
    .update diff
    .run()

  deleteById: (id) ->
    r.table USERS_TABLE
    .get id
    .delete()
    .run()

  sanitize: _.curry (requesterId, user) ->
    _.pick user, [
      'id'
    ]

module.exports = new UserModel()
