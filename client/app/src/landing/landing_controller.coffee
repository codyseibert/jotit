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
      $window.location.href = "http://notemanapi.seibertsoftwaresolutions.com/login/facebook"

    return this
]
