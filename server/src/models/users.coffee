mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

module.exports = new Schema
  email: String
  password: String
  salt: String
  fbId: String
  fbAccessToken: String
  data: Object
