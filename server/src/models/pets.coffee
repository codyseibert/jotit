mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

module.exports = new Schema
  name: String
  gender: String
  breed: String
  headline: String
  layout: String
  banner: String
  memory: String
  biography: String
  titleA: String
  snippitA: String
  story: String
  titleB: String
  snippitB: String
  imageA: String
  imageB: String
  imageC: String
  imageD: String
  imageE: String
  imageF: String
  imageG: String
  imageH: String
  imageI: String
  imageJ: String
  carousel: Array
  customerId: String
  isSubscriptionCanceled: Boolean
  subscriptionId: String
  userId: ObjectId
  activeUntil: Date
