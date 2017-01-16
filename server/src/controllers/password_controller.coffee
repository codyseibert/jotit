models = require '../models/models'
Users = models.Users
ObjectId = require('mongoose').Types.ObjectId
lodash = require 'lodash'
crypto = require 'crypto'
uuid = require 'node-uuid'
config = require '../config/config'
emailHelper = require '../helpers/email_helper'
Joi = require 'joi'
moment = require 'moment'

SALT_ROUNDS = 10

createSalt = ->
  Math.round((new Date().valueOf() * Math.random())) + ''

module.exports = do ->

  reset: (req, res) ->
    schema = Joi.object().keys
      password: Joi.string().required()
      resetUuid: Joi.string().required()
      userId: Joi.string().required()

    Joi.validate req.body, schema, (err, value) ->
      if err?
        res.status 400
        res.send err
      else
        salt = createSalt()
        hash = crypto
          .createHmac 'sha1', salt
          .update value.password
          .digest 'hex'

        Users.findOne
          _id: value.userId
          resetUuid: value.resetUuid
        .then (user) ->
          if not user?
            logger.error "a user requested to reset their password userId=#{value.userId}, but the user was not found"
            res.status 400
            res.send 'user was not found using the provided userId and resetUuid'
          else if moment(user.resetTTL).isBefore moment()
            logger.info "a user requested to reset their password, but the link was expired userId=#{value.userId} resetUuid=#{resetUuid}"
            res.status 400
            res.send 'the password reset link you are trying to access has expired, please request another reset from the "forgot password" page'
          else
            user.salt = salt
            user.password = hash
            user.resetUuid = null
            user.resetTTL = null
            user.save().then ->
              res.status 200
              res.send
                password: value.password
                email: user.email

  forgot: (req, res) ->
    Users.findOne(email: req.body.email).then (user) ->
      if not user?
        logger.error "a user has forgotten their password, but the user was not found email=#{req.body.email}"
        res.status 400
        res.send 'no user with the email was found'
      else
        today = new Date()
        today.setDate(today.getDate() + 1) # Add a day
        user.resetUuid = uuid.v4()
        user.resetTTL = today
        user.save ->
          emailHelper.send user.email, """
            Password Recovery
          """, """
            Please click the link below to reset your password:

            #{config.BASE_URL}/reset?userId=#{user._id}&resetUuid=#{user.resetUuid}
          """, (err) ->
            if err?
              logger.error "the password reset email failed to send to user email=#{user.email} userId=#{user._id} resetUuid=#{user.resetUuid}"
              res.status 500
              res.send 'the email was not sent ' + err
            else
              res.status 200
              res.send 'an email should have been sent to the user'
