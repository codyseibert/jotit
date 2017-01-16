models = require '../models/models'
Users = models.Users
ObjectId = require('mongoose').Types.ObjectId
lodash = require 'lodash'
uuid = require 'node-uuid'
fs = require 'fs'
AWS = require 'aws-sdk'

config = require '../config/config'

AWS.config.region = 'us-west-2'
s3bucket = new AWS.S3(
  params:
    Bucket: 'jotit'
)

module.exports = do ->

  post: (req, res) ->
    params =
      Key: uuid.v4()
      Body: fs.createReadStream(req.file.path)

    s3bucket.upload params, (err, data) ->
      if err
        res.status 400
        res.send err
      else
        res.status 200
        res.send data.Location
