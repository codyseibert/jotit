app = require('angular').module 'jotit'

app.controller 'LandingCtrl', require './landing_controller'
app.directive 'scrollPosition', require './scroll_position_directive'
