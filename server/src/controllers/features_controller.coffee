models = require '../models/models'
Users = models.Users

_ = require 'lodash'

module.exports = do ->

  index: (req, res) ->
    Users.find().then (users) ->
      res.status 200
      res.send _.flatten users.map (u) ->
        u.requests or []
