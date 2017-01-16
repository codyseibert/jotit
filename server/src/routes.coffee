app = require './app'
UsersCtrl = require './controllers/users_controller'
PetsCtrl = require './controllers/pets_controller'
ImagesCtrl = require './controllers/images_controller'
ChargeCtrl = require './controllers/charge_controller'
LoginCtrl = require './controllers/login_controller'
PasswordCtrl = require './controllers/password_controller'

userIsLoggedIn = require './helpers/user_is_logged_in'
userOwnsPet = require './helpers/user_owns_pet'
userOwnsUser = require './helpers/user_owns_user'
injectUser = require './helpers/inject_user'

multer = require 'multer'
upload = multer dest: '/tmp'

module.exports = do ->
  app.get '/users', UsersCtrl.index
  app.get '/users/:id', userIsLoggedIn, UsersCtrl.show
  app.post '/users', UsersCtrl.post

  app.post '/password/forgot', PasswordCtrl.forgot
  app.post '/password/reset', PasswordCtrl.reset

  app.post '/accounts/verify', UsersCtrl.verify

  app.get '/pets', userIsLoggedIn, PetsCtrl.index
  app.get '/pets/:id', injectUser, PetsCtrl.show
  app.post '/pets', userIsLoggedIn, PetsCtrl.post
  app.put '/pets/:id', userIsLoggedIn, userOwnsPet, PetsCtrl.put
  app.delete '/pets/:id/subscription', userIsLoggedIn, userOwnsPet, ChargeCtrl.delete

  app.post '/images', upload.single('file'), ImagesCtrl.post

  app.post '/charge', userIsLoggedIn, ChargeCtrl.post
  app.post '/stripe/webhook', ChargeCtrl.webhook

  app.post '/login', LoginCtrl.post

  app.post '/validate', LoginCtrl.validate

  app.get '/holla/users', UsersCtrl.getHolla
