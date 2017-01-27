app = require './app'
LoginCtrl = require './controllers/login_controller'
UsersCtrl = require './controllers/users_controller'
FeaturesCtrl = require './controllers/features_controller'

userIsLoggedIn = require './helpers/user_is_logged_in'
userOwnsUser = require './helpers/user_owns_user'

passport = require 'passport'
FacebookStrategy = require 'passport-facebook'

models = require './models/models'
Users = models.Users
ObjectId = require('mongoose').Types.ObjectId
_ = require 'lodash'
jwt = require 'jsonwebtoken'

config = require './config/config'
TOKEN_PASSWORD = config.JWT_PASSWORD

passport.use new FacebookStrategy
  clientID: '1901234816764848'
  clientSecret: 'dbd4fab3a392b289aa77826a9e07a08e'
  callbackURL: 'http://notemanapi.seibertsoftwaresolutions.com/login/facebook/callback'
  profileFields: ['email', 'id']
, (accessToken, refreshToken, profile, cb) ->
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
          cb null, obj
        else
          cb 'error creating the user'

module.exports = do ->

  app.get '/login/facebook',
    passport.authenticate 'facebook',
      session: false
      scope: ['email', 'publish_actions']

  app.get '/login/facebook/callback',
    passport.authenticate('facebook',
      failureRedirect: 'http://noteman.seibertsoftwaresolutions.com'
      session: false
    )
    , (req, res) ->
      if req.user?
        user =
          _id: req.user._id
          fbId: req.user.fbId
          fbAccessToken: req.user.fbAccessToken
        jwt.sign user, TOKEN_PASSWORD, algorithm: 'HS256', (err, token) ->
          res.redirect "http://noteman.seibertsoftwaresolutions.com/topics?t=#{token}"
      else
        res.status 400
        res.send 'user not found'

  app.post '/login', LoginCtrl.post

  app.get '/features', FeaturesCtrl.index

  app.post '/users', UsersCtrl.post
  app.get '/users/:id', userIsLoggedIn, userOwnsUser, UsersCtrl.show
  app.put '/users/:id', userIsLoggedIn, userOwnsUser, UsersCtrl.put
