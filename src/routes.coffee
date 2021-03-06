router = require 'exoid-router'

UserCtrl = require './controllers/user'
AuthCtrl = require './controllers/auth'

authed = (handler) ->
  unless handler?
    return null

  (body, req, rest...) ->
    unless req.userId?
      router.throw status: 401, message: 'Unauthorized'

    handler body, req, rest...

module.exports = router
# Public Routes
.on 'auth.login', AuthCtrl.login

# Authed Routes
.on 'users.getMe', authed UserCtrl.getMe
