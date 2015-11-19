_ = require 'lodash'
assertNoneMissing = require 'assert-none-missing'

env = process.env

config =
  VERBOSE: if env.VERBOSE then env.VERBOSE is '1' else true
  PORT: env.PORT or 50000
  ENV: env.NODE_ENV
  RETHINK:
    DB: env.RETHINK_DB or 'exoid_seed'
    HOST: env.RETHINK_HOST or 'localhost'
  ENVS:
    DEV: 'development'
    PROD: 'production'
    TEST: 'test'

assertNoneMissing config

module.exports = config
