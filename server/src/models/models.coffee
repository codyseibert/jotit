mongoose = require 'mongoose'

Users = require './users'
Pets = require './pets'

models =
  Users: mongoose.model 'Users', Users
  Pets: mongoose.model 'Pets', Pets

module.exports = models
