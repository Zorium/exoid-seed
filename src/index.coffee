fs = require 'fs'
_ = require 'lodash'
log = require 'winston'
cors = require 'cors'
express = require 'express'
bodyParser = require 'body-parser'

config = require '../config'
routes = require './routes'
r = require './services/rethinkdb'
AuthService = require './services/auth'

HEALTHCHECK_TIMEOUT = 1000
MAX_CLIENT_LOG_LENGTH = 500

unless config.VERBOSE
  log.level = 'warn'

# Setup rethinkdb
createDatabaseIfNotExist = (dbName) ->
  r.dbList()
  .contains dbName
  .do (result) ->
    r.branch result,
      {created: 0},
      r.dbCreate dbName
  .run()

createTableIfNotExist = (tableName, options) ->
  r.tableList()
  .contains tableName
  .do (result) ->
    r.branch result,
      {created: 0},
      r.tableCreate tableName, options
  .run()

createIndexIfNotExist = (tableName, indexName, indexFn, indexOpts) ->
  r.table tableName
  .indexList()
  .contains indexName
  .run() # can't use r.branch() with r.row() compound indexes
  .then (isCreated) ->
    unless isCreated
      (if indexFn?
        r.table tableName
        .indexCreate indexName, indexFn, indexOpts
      else
        r.table tableName
        .indexCreate indexName, indexOpts
      ).run()

setup = ->
  createDatabaseIfNotExist config.RETHINK.DB
  .then ->
    Promise.all _.map fs.readdirSync("#{__dirname}/models"), (modelFile) ->
      model = require('./models/' + modelFile)
      tables = model?.RETHINK_TABLES or []

      Promise.all _.map tables, (table) ->
        createTableIfNotExist table.name, table.options
        .then ->
          Promise.all _.map (table.indexes or []), ({name, fn, options}) ->
            fn ?= null
            createIndexIfNotExist table.name, name, fn, options
        .then ->
          r.table(table.name).indexWait().run()

app = express()

app.set 'x-powered-by', false

app.use cors()
app.use bodyParser.json()
# Avoid CORS preflight
app.use bodyParser.json({type: 'text/plain'})
app.use AuthService.middleware

app.get '/ping', (req, res) -> res.send 'pong'

app.get '/healthcheck', (req, res, next) ->
  settle = (promise) ->
    new Promise (resolve, reject) ->
      setTimeout reject, HEALTHCHECK_TIMEOUT
      promise.then resolve
      .catch reject
    .then -> true
    .catch -> false

  Promise.all(_.map [
    r.dbList().run()
  ], settle)
  .then ([rethinkdb]) ->
    result = {rethinkdb}
    result.healthy = _.every _.values result
    return result
  .then (status) -> res.json status
  .catch next

app.post '/log', (req, res) ->
  if req.body?.event isnt 'client_error' or
    JSON.stringify(req.body).length > MAX_CLIENT_LOG_LENGTH
      return res.status(400).send 'invalid client_error'

  log.info req.body
  res.status(204).send()

app.post '/exoid', routes.asMiddleware()

module.exports = {
  app
  setup
}
