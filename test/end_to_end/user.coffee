_ = require 'lodash'
b = require 'b-assert'
server = require '../../index'
flare = require('flare-gun').express(server.app)

schemas = require '../../schemas'

RANDOM_ID = '08841ff6-2c80-493f-81b0-c1a9c486b1b0'

describe 'User Routes', ->
  describe 'users.create', ->
    it 'returns new user', ->
      flare
        .exoid 'users.create', {username: 'test'}
        .expect schemas.user

    describe '400', ->
      it 'fails with invalid username', ->
        flare
          .exoid 'users.create', {username: 123}
          .expect 400

  describe 'users.get', ->
    it 'returns user', ->
      flare
        .exoid 'users.create', {username: 'test'}
        .stash 'me'
        .exoid 'users.get', ':me.id'
        .expect ':me'

    describe '400', ->
      it 'returns 404 if user not found', ->
        flare
          .exoid 'users.get', RANDOM_ID
          .expect 404

  describe 'users.update', ->
    it 'updates user', ->
      flare
        .exoid 'users.create', {username: 'test'}
        .stash 'me'
        .exoid 'users.update', {id: ':me.id', username: 'changed'}
        .expect _.defaults {
          username: 'changed'
        }, schemas.user
        .exoid 'users.get', ':me.id'
        .expect _.defaults {
          username: 'changed'
        }, schemas.user

    describe '400', ->
      it 'fails if invalid update values', ->
        flare
          .exoid 'users.create', {username: 'test'}
          .stash 'me'
          .exoid 'users.update', {id: ':me.id', username: 123}
          .expect 400

      it 'returns 404 if user not found', ->
        flare
          .exoid 'users.update', {id: RANDOM_ID}
          .expect 404

  describe 'users.delete', ->
    it 'removes user', ->
      flare
        .exoid 'users.create', {username: 'test'}
        .stash 'me'
        .exoid 'users.delete', ':me.id'
        .expect ({cache}, {me}) ->
          b cache.length, 1
          b cache[0].path, me.id
          b cache[0].body, undefined
        .exoid 'users.get', ':me.id'
        .expect 404

    describe '400', ->
      it 'returns 404 if user not found', ->
        flare
          .exoid 'users.delete', RANDOM_ID
          .expect 404
