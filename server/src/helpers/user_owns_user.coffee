Base64 = require('js-base64').Base64
Users = require('../models/models').Users

module.exports = (req, res, next) ->

  userId = req.params.id
  
  if "#{userId}" isnt "#{req.user._id}"
    res.status 400
    res.send 'You do not have access to this user'

  Users.findById(userId).then (user) ->
    if not user?
      res.status 404
      res.send 'user not found with id'
      return
    next()
