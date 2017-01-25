app = require './app'
LoginCtrl = require './controllers/login_controller'
UsersCtrl = require './controllers/users_controller'

userIsLoggedIn = require './helpers/user_is_logged_in'
userOwnsUser = require './helpers/user_owns_user'

passport = require 'passport'
FacebookStrategy = require 'passport-facebook'

models = require './models/models'
Users = models.Users
ObjectId = require('mongoose').Types.ObjectId
_ = require 'lodash'

config = require './config/config'
TOKEN_PASSWORD = config.JWT_PASSWORD

passport.use new FacebookStrategy
  clientID: '1901234816764848'
  clientSecret: 'dbd4fab3a392b289aa77826a9e07a08e'
  callbackURL: 'http://jotitapi.seibertsoftwaresolutions.com/login/facebook/callback'
, (accessToken, refreshToken, profile, cb) ->
  process.nextTick ->
    Users.findOne(fbId: profile.id).then (u) ->
      if u?
        cb null, u
      else
        user =
          fbId: profile.id
          fbAccessToken: accessToken
          email: profile.emails[0].value
        Users.create(user).then (obj) ->
          if obj?
            cb null, obj?
          else
            cb 'error creating the user'

module.exports = do ->

  app.get '/login/facebook',
    passport.authenticate 'facebook',
      session: false
      scope: ['email']

  app.get '/login/facebook/callback',
    passport.authenticate 'facebook',
      failureRedirect: 'http://jotit.seibertsoftwaresolutions.com'
      session: false
    , (req, res) ->
      User.findOne(fbAccessToken: req.user.access_token).then (u) ->
        if u?
          jwt.sign u, TOKEN_PASSWORD, algorithm: 'HS256', (err, token) ->
            res.redirect "http://jotit.seibertsoftwaresolutions.com?t=#{token}"
        else
          res.status 400
          res.send 'user not found'

  app.post '/login', LoginCtrl.post

  app.post '/users', UsersCtrl.post
  app.get '/users/:id', userIsLoggedIn, userOwnsUser, UsersCtrl.show
  app.put '/users/:id', userIsLoggedIn, userOwnsUser, UsersCtrl.put
