_ = require 'lodash'
b = require 'b-assert'
server = require '../../src'
flare = require('flare-gun').express(server.app)

schemas = require '../../src/schemas'
util = require './util'

describe 'User Routes', ->
  describe 'users.getMe', ->
    it 'returns user', ->
      flare
        .thru util.login()
        .exoid 'users.getMe'
        .expect schemas.user

    describe '400', ->
      it 'fails if missing accessToken', ->
        flare
          .exoid 'users.getMe'
          .expect 401
