server = require '../../src'
flare = require('flare-gun').express(server.app)

schemas = require '../../src/schemas'

describe 'Auth Routes', ->
  describe 'auth.login', ->
    it 'returns auth for anon user', ->
      flare
        .exoid 'auth.login'
        .expect schemas.auth
