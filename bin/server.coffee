#!/usr/bin/env coffee
_ = require 'lodash'
log = require 'loga'
cluster = require 'cluster'
os = require 'os'

{setup, app} = require '../src'
config = require '../config'

if config.ENV is config.ENVS.PROD
  if cluster.isMaster
    setup().then ->
      _.map _.range(os.cpus().length), ->
        cluster.fork()

      cluster.on 'exit', (worker) ->
        log "Worker #{worker.id} died, respawning"
        cluster.fork()
    .catch log.error
  else
    app.listen config.PORT, ->
      log.info 'Worker %d, listening on port %d', cluster.worker.id, config.PORT
else
  setup().then ->
    app.listen config.PORT, ->
      log.info 'Server listening on port %d', config.PORT
  .catch log.error
