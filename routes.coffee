router = require 'exoid-router'

UserCtrl = require './controllers/user'

###################
# Public Routes   #
###################

module.exports = router
.on 'users.get', UserCtrl.get
.on 'users.create', UserCtrl.create
.on 'users.update', UserCtrl.update
.on 'users.delete', UserCtrl.delete
.asMiddleware()
