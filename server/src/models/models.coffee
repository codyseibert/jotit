mongoose = require 'mongoose'

Users = require './users'

models =
  Users: mongoose.model 'Users', Users

module.exports = models
