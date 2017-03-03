log = require 'winston'

Auth = require '../models/auth'
User = require '../models/user'

class AuthService
  middleware: (req, res, next) ->
    # set req.user if authed
    accessToken = req.query?.accessToken

    unless accessToken?
      return next()

    Auth.userIdFromAccessToken accessToken
    .then (userId) ->
      if userId?
        # Authentication successful
        req.userId = userId
      next()
    .catch (err) ->
      log.warn err
      next()

module.exports = new AuthService()
