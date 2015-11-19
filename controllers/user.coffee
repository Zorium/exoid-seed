_ = require 'lodash'
router = require 'exoid-router'

User = require '../models/user'
schemas = require '../schemas'

class UserCtrl
  create: ({username} = {}) ->
    router.assert {username}, {
      username: schemas.user.username
    }

    User.create {username}
    .then User.sanitize(null)

  get: (id) ->
    router.assert id, schemas.user.id

    User.getById id
    .tap (user) ->
      unless user
        router.throw status: 404, info: 'user not found'
    .then User.sanitize(null)

  update: (body) ->
    updateSchema =
      id: schemas.user.id
      username: schemas.user.username.optional()

    diff = _.pick body, _.keys(updateSchema)

    router.assert diff, updateSchema

    User.updateById diff.id, diff
    .then ({replaced}) ->
      if replaced is 0
        router.throw status: 404, detail: 'user not found'
      User.getById diff.id
    .then User.sanitize(null)

  delete: (body, {cache}) ->
    id = body

    router.assert id, schemas.user.id

    User.deleteById(id)
    .then ({deleted}) ->
      if deleted is 0
        router.throw status: 404, detail: 'user not found'
    .then ->
      cache id, undefined
      null


module.exports = new UserCtrl()
