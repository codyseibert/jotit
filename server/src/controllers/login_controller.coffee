models = require '../models/models'
Users = models.Users
ObjectId = require('mongoose').Types.ObjectId
lodash = require 'lodash'
jwt = require 'jsonwebtoken'
crypto = require 'crypto'

config = require '../config/config'
TOKEN_PASSWORD = config.JWT_PASSWORD

module.exports = do ->

  # used by HollaBack
  validate: (req, res) ->
    try
      jwt.verify req.body.token, TOKEN_PASSWORD, (err, decoded) ->
        if err?
          res.status 403
          res.send 'the token was invalid'
        else
          if not decoded?._id?
            res.status 400
            res.send 'token was valid, but contained no user id'
          else
            res.status 200
            res.send userId: decoded._id
    catch err
      res.send 404
      res.send 'issue decrypting the token'

  post: (req, res) ->
    email = req.body.email
    password = req.body.password

    Users.findOne(email: email)
      .then (user) ->
        user = user.toObject()
        if not user?
          res.status 404
          res.send 'user not found'
        else
          hash = crypto
            .createHmac 'sha1', user.salt
            .update password
            .digest 'hex'

          if hash is user.password
            jwt.sign user, TOKEN_PASSWORD, algorithm: 'HS256', (err, token) ->
              res.status 200
              res.send token
          else
            res.status 401
            res.send 'invalid password'
