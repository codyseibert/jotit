window.$ = require 'jquery'
window.moment = require 'moment'
angular = require 'angular'
require 'angular-scroll'
require 'angular-filter'
require 'angular-animate'
require 'angular-local-storage'
require 'ng-lodash'
require '../../node_modules/angular-ui-bootstrap/dist/ui-bootstrap-tpls'
require '../../node_modules/textangular/dist/textAngular-rangy.min'
require '../../node_modules/textangular/dist/textAngular-sanitize.min'
require '../../node_modules/textangular/dist/textAngular.min'
require 'ng-file-upload'
require 'angular-marked'
require 'fullcalendar'
require 'angular-ui-calendar'
require '@iamadamjowett/angular-click-outside'
require 'angular-chart.js'
require 'angular-jwt'

app = require('angular').module('jotit', [
  require 'angular-ui-router'
  require 'angular-resource'
  'ngAnimate'
  'angular-click-outside'
  'textAngular'
  'duScroll'
  'angular.filter'
  'ngFileUpload'
  'LocalStorageModule'
  'ngLodash'
  'ui.bootstrap'
  'hc.marked'
  'ui.calendar'
  'chart.js'
  'angular-jwt'
  require 'angular-moment'
])

app.value 'duScrollDuration', 500
app.value 'duScrollOffset', 70

app.factory 'AuthorizationInterceptor', require './authorization_interceptor'

require './services'

app.config require './routes'

app.config [
  'localStorageServiceProvider'
  (
    localStorageServiceProvider
  ) ->
    localStorageServiceProvider
      .setPrefix 'jotit-dev'
]

app.config ['$httpProvider', ($httpProvider) ->
  $httpProvider.interceptors.push 'AuthorizationInterceptor'
]

require './main'
require './login'
require './landing'
require './tos'
require './pp'

app.constant 'API_PATH', 'http://localhost:8081'

app.directive 'ngEnter', ->
  (scope, element, attrs) ->
    element.bind 'keydown keypress', (event) ->
      if event.which == 13
        scope.$apply ->
          scope.$eval attrs.ngEnter, 'event': event
          return
        event.preventDefault()
      return
    return

app.run [
  '$location'
  'TokenService'
  (
    $location
    TokenService
  ) ->

    if $location.search().t?
      TokenService.setToken $location.search().t

]
