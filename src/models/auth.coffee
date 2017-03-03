_ = require 'lodash'
uuid = require 'node-uuid'
jwt = require 'jsonwebtoken'

config = require '../../config'

generateAccessToken = (userId) ->
  jwt.sign {
    userId: userId
    scopes: ['*']
  }, config.JWT_ES256_PRIVATE_KEY, {
    algorithm: 'ES256'
    issuer: config.JWT_ISSUER
    subject: userId
  }

decodeAccessToken = (token) ->
  new Promise (resolve, reject) ->
    jwt.verify token,
      config.JWT_ES256_PUBLIC_KEY,
      {issuer: config.JWT_ISSUER},
      (err, res) -> if err? then reject(err) else resolve(res)

class AuthModel
  fromUserId: (userId) ->
    {accessToken: generateAccessToken(userId)}

  userIdFromAccessToken: (token) ->
    decodeAccessToken(token)
    .then ({userId} = {}) -> userId

module.exports = new AuthModel()
