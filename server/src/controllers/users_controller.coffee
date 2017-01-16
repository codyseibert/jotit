models = require '../models/models'
Users = models.Users
Pets = models.Pets
ObjectId = require('mongoose').Types.ObjectId
crypto = require 'crypto'
uuid = require 'node-uuid'
config = require '../config/config'
Joi = require 'joi'

_ = require 'lodash'

log4js = require 'log4js'
logger = log4js.getLogger 'app'

SALT_ROUNDS = 10

createSalt = ->
  Math.round((new Date().valueOf() * Math.random())) + ''

module.exports = do ->

  show: (req, res) ->
    Users.findById(req.params.id).then (user) ->
      if not user?
        res.status 404
        res.send 'user not found'
      else
        res.status 200
        res.send user

  post: (req, res) ->
    user = req.body
    salt = createSalt()

    hash = crypto
      .createHmac 'sha1', salt
      .update user.password
      .digest 'hex'

    user.salt = salt
    user.password = hash

    Users.findOne(email: user.email).then (u) ->
      if u?
        logger.info "a user tried to create a user with an email that already existed email=#{user.email}"
        res.status 400
        res.send 'user already exists with this email'
      else
        Users.create(user).then (obj) ->
          if not obj?
            logger.error "there was an error creating a new user email=#{email}"
            res.status 400
            res.send 'there was an error creating the user'
          else
            res.status 200
            res.send user

  put: (req, res) ->
    Users.update(_id: new ObjectId(req.params.id), req.body).then (obj) ->
      res.status 200
      res.send obj
