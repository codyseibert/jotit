app = require('angular').module 'jotit'

app.service 'SecurityService', require './security_service'
app.service 'TokenService', require './token_service'
app.service 'UsersService', require './users_service'
