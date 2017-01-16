mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

module.exports = new Schema
  email: String
  password: String
  salt: String
  verify: String
  verified: Boolean
  resetUuid: String
  resetTTL: Date
