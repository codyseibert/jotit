module.exports = [
  '$scope'
  '$state'
  '$timeout'
  '$window'
  'UsersService'
  'TokenService'
  'lodash'
  (
    $scope
    $state
    $timeout
    $window
    UsersService
    TokenService
    _
  ) ->

    $scope.loginWithFacebook = ->
      $window.location.href = "http://jotitapi.seibertsoftwaresolutions.com/login/facebook"

    return this
]
