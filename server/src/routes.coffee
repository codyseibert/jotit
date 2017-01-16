app = require './app'
LoginCtrl = require './controllers/login_controller'
UsersCtrl = require './controllers/users_controller'

userIsLoggedIn = require './helpers/user_is_logged_in'
userOwnsUser = require './helpers/user_owns_user'

# multer = require 'multer'
# upload = multer dest: '/tmp'

module.exports = do ->

  app.post '/login', LoginCtrl.post

  app.post '/users', UsersCtrl.post
  app.get '/users/:id', userIsLoggedIn, userOwnsUser, UsersCtrl.show
  app.put '/users/:id', userIsLoggedIn, userOwnsUser, UsersCtrl.put
